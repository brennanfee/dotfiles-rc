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

#if [[ ! -f /etc/init.d/dns-sync.sh ]]; then
#  sudo cp "$DOTFILES/bin/dns-sync.sh" /etc/init.d/dns-sync.sh
#fi

#if sudo service dns-sync.sh status | grep -q 'dns-sync is not running'; then
#  sudo service dns-sync.sh start
#fi
