#!/usr/bin/env bash
# shellcheck disable=2310

# Bash strict mode
# shellcheck disable=SC2154
([[ -n ${ZSH_EVAL_CONTEXT} && ${ZSH_EVAL_CONTEXT} =~ :file$ ]] \
  || [[ -n ${BASH_VERSION} ]] && (return 0 2> /dev/null)) && SOURCED=true || SOURCED=false
if ! ${SOURCED}; then
  set -o errexit  # same as set -e
  set -o nounset  # same as set -u
  set -o errtrace # same as set -E
  set -o pipefail
  set -o posix
  #set -o xtrace # same as set -x, turn on for debugging

  shopt -s extdebug
  IFS=$(printf '\n\t')
fi
# END Bash strict mode

shopt -s inherit_errexit

# Copyright 2012-2021, Andrey Kislyuk and argcomplete contributors.
# Licensed under the Apache License. See https://github.com/kislyuk/argcomplete for more info.

# Copy of __expand_tilde_by_ref from bash-completion
__python_argcomplete_expand_tilde_by_ref() {
  if [[ "${!1:0:1}" = "~" ]]; then
    if [[ "${!1}" != "${!1//\//}" ]]; then
      eval "$1"="${!1/%\/*/}"/'${!1#*/}'
    else
      eval "$1"="${!1}"
    fi
  fi
}

# Run something, muting output or redirecting it to the debug stream
# depending on the value of _ARC_DEBUG.
# If ARGCOMPLETE_USE_TEMPFILES is set, use tempfiles for IPC.
__python_argcomplete_run() {
  if [[ -z "${ARGCOMPLETE_USE_TEMPFILES-}" ]]; then
    __python_argcomplete_run_inner "$@"
    return
  fi
  local tmpfile
  tmpfile="$(mktemp)"
  _ARGCOMPLETE_STDOUT_FILENAME="${tmpfile}" __python_argcomplete_run_inner "$@"
  local code=$?
  cat "${tmpfile}"
  rm "${tmpfile}"
  return "${code}"
}

__python_argcomplete_run_inner() {
  if [[ -z "${_ARC_DEBUG-}" ]]; then
    "$@" 8>&1 9>&2 1> /dev/null 2>&1
  else
    "$@" 8>&1 9>&2 1>&9 2>&1
  fi
}

# Scan the beginning of an executable file ($1) for a regexp ($2). By default,
# scan for the magic string indicating that the executable supports the
# argcomplete completion protocol. By default, scan the first kilobyte;
# if $3 is set to -n, scan until the first line break up to a kilobyte.
__python_argcomplete_scan_head() {
  read -s -r "${3:--N}" 1024 < "$1"
  [[ "${REPLY}" =~ ${2:-PYTHON_ARGCOMPLETE_OK} ]]
}

__python_argcomplete_scan_head_noerr() {
  __python_argcomplete_scan_head "$@" 2> /dev/null
}

_python_argcomplete_global() {
  local executable=$1
  __python_argcomplete_expand_tilde_by_ref executable

  local ARGCOMPLETE=0
  if [[ "${executable}" == python* ]] || [[ "${executable}" == pypy* ]]; then
    if [[ "${COMP_WORDS[1]}" == -m ]]; then
      if __python_argcomplete_run "${executable}" -m argcomplete._check_module "${COMP_WORDS[2]}"; then
        ARGCOMPLETE=3
      else
        return
      fi
    elif [[ -f "${COMP_WORDS[1]}" ]] && __python_argcomplete_scan_head_noerr "${COMP_WORDS[1]}"; then
      ARGCOMPLETE=2
    else
      return
    fi
  elif type -P "${executable}" > /dev/null 2>&1; then
    local SCRIPT_NAME
    SCRIPT_NAME=$(type -P "${executable}")
    if (type -t pyenv && [[ "${SCRIPT_NAME}" = $(pyenv root || true)/shims/* ]]) > /dev/null 2>&1; then
      SCRIPT_NAME=$(pyenv which "${executable}")
    fi
    if __python_argcomplete_scan_head_noerr "${SCRIPT_NAME}"; then
      ARGCOMPLETE=1
    elif __python_argcomplete_scan_head_noerr "${SCRIPT_NAME}" '^#!(.*)$' -n && [[ "${BASH_REMATCH[1]}" =~ ^.*(python|pypy)[0-9\.]*$ ]]; then
      local interpreter="${BASH_REMATCH}"
      if (__python_argcomplete_scan_head_noerr "${SCRIPT_NAME}" "(PBR Generated)|(EASY-INSTALL-(SCRIPT|ENTRY-SCRIPT|DEV-SCRIPT))" \
        && "${interpreter}" "$(type -P python-argcomplete-check-easy-install-script || true)" "${SCRIPT_NAME}") > /dev/null 2>&1; then
        ARGCOMPLETE=1
      elif __python_argcomplete_run "${interpreter}" -m argcomplete._check_console_script "${SCRIPT_NAME}"; then
        ARGCOMPLETE=1
      fi
    fi
  fi

  if [[ ${ARGCOMPLETE} != 0 ]]; then
    local IFS
    IFS=$(echo -e '\v')
    # shellcheck disable=2207
    COMPREPLY=($(_ARGCOMPLETE_IFS="${IFS}" \
      COMP_LINE="${COMP_LINE}" \
      COMP_POINT="${COMP_POINT}" \
      COMP_TYPE="${COMP_TYPE}" \
      _ARGCOMPLETE_COMP_WORDBREAKS="${COMP_WORDBREAKS}" \
      _ARGCOMPLETE="${ARGCOMPLETE}" \
      _ARGCOMPLETE_SUPPRESS_SPACE=1 \
      __python_argcomplete_run "${executable}" "${COMP_WORDS[@]:1:ARGCOMPLETE-1}"))
    if [[ $? != 0 ]]; then
      unset COMPREPLY
    elif [[ "${COMPREPLY-}" =~ [=/:]$ ]]; then
      compopt -o nospace
    fi
  else
    type -t _completion_loader | grep -q 'function' && _completion_loader "$@"
  fi
}

if command_exists register-python-argcomplete || command_exists register-python-argcomplete3; then
  complete -o default -o bashdefault -D -F _python_argcomplete_global
fi
