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

export NAME_FIRST="Brennan"
export NAME_LAST="Fee"
export NAME="Brennan Fee"
export NAME_FULL="${NAME}"

export HOME_EMAIL="brennan+shell@mailbots.org"
export WORK_EMAIL="febrenna@amazon.com"

export EMAIL="${HOME_EMAIL}"

rc_tags=$(grep -i '^TAGS=' "${HOME}/.rcrc" | sed -e 's/^TAGS=//' | tr '[:upper:]' '[:lower:]')
if [[ ${rc_tags} == *"work"* ]]; then
  export EMAIL="${WORK_EMAIL}"
fi

unset rc_tags
