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

function reload_profile() {
  source_or_error "${HOME}/.bash_profile"
}

function myip() {
  curl ifconfig.co/ip
}

function usage() {
  if [[ -n "$1" ]]; then
    du -h --max-depth=1 "$1" | sort -hr
  else
    du -h --max-depth=1 | sort -hr
  fi
}

function weather() {
  curl -sL "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=${1:-<YOURZIPORLOCATION>}" | perl -ne '/<title>([^<]+)/&&printf "%s: ",$1;/<fcttext>([^<]+)/&&print $1,"\n"'
}
