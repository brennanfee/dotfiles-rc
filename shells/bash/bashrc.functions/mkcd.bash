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

function mkbk() {
  if [[ -z "$1" ]]; then
    # shellcheck disable=SC2154
    echo -e "${text_red}Enter a file name${text_reset}"
  else
    local filename=$1
    local filetime
    filetime=$(date +%Y%m%d_%H%M%S)
    cp "${filename}" "${filename}_${filetime}"
  fi
}

alias mkback='mkbk'
alias bk='mkbk'

function mkorig() {
  if [[ -z "$1" ]]; then
    echo -e "${text_red}Enter a file name${text_reset}"
  else
    cp "${1}" "${1}.orig"
  fi
}

function mkcd() {
  if [[ -z "$1" ]]; then
    echo -e "${text_red}Enter a directory name${text_reset}"
  else
    mkdir -p "$1" && cd "$1" || return
  fi
}
