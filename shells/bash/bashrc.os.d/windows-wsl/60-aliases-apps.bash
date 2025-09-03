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

# Aliases for linux apps, redirecting to windows versions

if [[ -e "/mnt/c/Program\ Files/Vim/vim82/gvim.exe" ]]; then
  alias gvim="/mnt/c/Program\ Files/Vim/vim82/gvim.exe"
fi

alias docker="docker.exe"
alias docker-compose="docker-compose.exe"
alias docker-machine="docker-machine.exe"
alias kubectl="kubectl.exe"
alias notary="notary.exe"

alias vagrant="vagrant.exe"

if [[ -e "/mnt/c/Program\ Files/Beyond\ Compare\ 4/BCompare.exe" ]]; then
  alias bcomp="/mnt/c/Program\ Files/Beyond\ Compare\ 4/BCompare.exe"
  alias bcompare="/mnt/c/Program\ Files/Beyond\ Compare\ 4/BCompare.exe"
fi
