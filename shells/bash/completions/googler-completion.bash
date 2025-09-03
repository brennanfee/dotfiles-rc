#!/usr/bin/env bash

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

#
# Rudimentary Bash completion definition for googler.
#
# Author:
#   Zhiming Wang <zmwangx@gmail.com>
#

_googler() {
  COMPREPLY=()
  local IFS=$' \n'
  local cur=$2 prev=$3
  local opts=(
    -h --help
    -s --start
    -n --count
    -N --news
    -c --tld
    -l --lang
    -x --exact
    -C --nocolor
    --colors
    -j --first --lucky
    -t --time
    -w --site
    --unfilter
    -p --proxy
    --noua
    --notweak
    --json
    --url-handler
    --show-browser-logs
    --np --noprompt
    -u --upgrade
    --include-git
    -v --version
    -d --debug
  )
  local opts_with_arg=(
    -s --start
    -n --count
    -c --tld
    -l --lang
    --colors
    -t --time
    -w --site
    -p --proxy
    --url-handler
  )

  if [[ ${cur} == -* ]]; then
    # The current argument is an option -- complete option names.
    # shellcheck disable=2207
    COMPREPLY=($(compgen -W "${opts[*]}" -- "${cur}"))
  else
    # Do not complete option arguments; only autocomplete positional
    # arguments (queries).
    for opt in "${opts_with_arg[@]}"; do
      [[ ${opt} == "${prev}" ]] && return 1
    done

    local completion
    COMPREPLY=()
    while IFS= read -r completion; do
      # Quote spaces for `complete -W wordlist`
      COMPREPLY+=("${completion// /\\ }")
    done < <(googler --complete "${cur}" || true)
  fi

  return 0
}

complete -F _googler googler
