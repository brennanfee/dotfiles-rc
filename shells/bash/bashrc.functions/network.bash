#!/usr/bin/env bash

# Bash strict mode
([[ -n ${ZSH_EVAL_CONTEXT} && ${ZSH_EVAL_CONTEXT} =~ :file$ ]] \
  || [[ -n ${BASH_VERSION} ]] && (return 0 2> /dev/null)) && SOURCED=true || SOURCED=false
if ! ${SOURCED}; then
  set -o errexit  # same as set -e
  set -o nounset  # same as set -u
  set -o errtrace # same as set -E
  set -o pipefail
  set -o posix
  #set -o xtrace # same as set -x, turn on for debugging

  shopt -s inherit_errexit
  shopt -s extdebug
  IFS=$(printf '\n\t')
fi
# END Bash strict mode

# Network utility functions

# Two methods to check if the machine has an active and working local network
# connection.  NOTE: This DOES NOT check for an INTERNET connection.
# This first version should be used with get_exit_code while the second version
# will produce an error message and exit if the network connection is not
# available.
check_network_connection() {
  # Check localhost first (if network stack is up at all)
  if ping -q -w 3 -c 2 localhost &> /dev/null; then
    # Test the gateway
    gateway_ip=$(ip r | grep default | awk 'NR==1 {print $3}')
    if ping -q -w 3 -c 2 "${gateway_ip}" &> /dev/null; then
      # Should we also ping the install mirror?
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

check_network_connection_with_error() {
  get_exit_code check_network_connection
  # shellcheck disable=2154
  if [[ ${EXIT_CODE} -ne 0 ]]; then
    local error_message=${1:-"ERROR!  Network is not accessible."}
    local error_code=${2:-"1"}

    local T_COLS
    T_COLS=$(tput cols)
    T_COLS=$((T_COLS - 1))

    # shellcheck disable=2154
    echo -e "${text_red}${error_message}${text_reset}\n" | fold -sw "${T_COLS}"
    exit "${error_code}"
  fi
}

# Two methods to check if the machine has an active and working internet
# connection.  NOTE: Even if this method fails the machine still may have a valid
# local network connection.
# This first version should be used with get_exit_code while the second version
# will produce an error message and exit if the internet connection is not
# available.
check_internet_connection() {
  # Check localhost first (if network stack is up at all)
  if ping -q -w 3 -c 2 localhost &> /dev/null; then
    # Test the gateway
    if ping -q -w 3 -c 2 "google.com" &> /dev/null; then
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

check_internet_connection_with_error() {
  get_exit_code check_internet_connection "$3"
  if [[ ${EXIT_CODE} -ne 0 ]]; then
    local error_message=${1:-"ERROR!  Internet is not accessible."}
    local error_code=${2:-"1"}

    local T_COLS
    T_COLS=$(tput cols)
    T_COLS=$((T_COLS - 1))

    # shellcheck disable=2154
    echo -e "${text_red}${error_message}${text_reset}\n" | fold -sw "${T_COLS}"
    exit "${error_code}"
  fi
}

# Two methods to check if the machine has an active and working connection
# to a specific site.  NOTE: Even if this method fails the machine still may
# have a valid internet or local network connection.
# This first version should be used with get_exit_code while the second version
# will produce an error message and exit if the internet connection is not
# available.
check_site_connection() {
  if [[ -n $1 ]]; then
    return 2
  fi

  # Check localhost first (if network stack is up at all)
  if ping -q -w 3 -c 2 localhost &> /dev/null; then
    # Test the gateway
    if ping -q -w 3 -c 2 "$1" &> /dev/null; then
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

check_site_connection_with_error() {
  local T_COLS
  T_COLS=$(tput cols)
  T_COLS=$((T_COLS - 1))

  get_exit_code check_site_connection "$1"

  if [[ ${EXIT_CODE} -eq 2 ]]; then
    local msg="You must pass in a site to check."
    echo -e "${text_red}${msg}${text_reset}\n" | fold -sw "${T_COLS}"
    exit 2
  fi

  if [[ ${EXIT_CODE} -ne 0 ]]; then
    local error_message=${1:-"ERROR!  Site '${1}' is not accessible."}
    local error_code=${2:-"1"}

    # shellcheck disable=2154
    echo -e "${text_red}${error_message}${text_reset}\n" | fold -sw "${T_COLS}"
    exit "${error_code}"
  fi
}
