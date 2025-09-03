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

if ! is_wsl; then
  # Configure ask pass
  if type ksshaskpass > /dev/null 2>&1; then
    SSH_ASKPASS=$(command -v ksshaskpass)
    export SSH_ASKPASS
    export SSH_ASKPASS_REQUIRE=prefer
  elif type x11-ssh-askpass > /dev/null 2>&1; then
    SSH_ASKPASS=$(command -v x11-ssh-askpass)
    export SSH_ASKPASS
    export SSH_ASKPASS_REQUIRE=prefer
  elif type ssh-askpass > /dev/null 2>&1; then
    SSH_ASKPASS=$(command -v ssh-askpass)
    export SSH_ASKPASS
    export SSH_ASKPASS_REQUIRE=prefer
  fi
fi

# Set up ssh-agent
SSH_ENV="${HOME}/.ssh/environment"

function start_agent() {
  echo "Initializing new SSH agent..."

  [[ -f ${SSH_ENV} ]] && rm "${SSH_ENV}" > /dev/null
  touch "${SSH_ENV}"
  chmod 600 "${SSH_ENV}"
  /usr/bin/ssh-agent | tee "${SSH_ENV}"
  sed -i 's/^echo/#echo/' "${SSH_ENV}" || true
  # shellcheck source=/dev/null
  source "${SSH_ENV}" > /dev/null

  if command_exists ssh-add-keys; then
    ssh-add-keys
  fi
}

# Source SSH settings, if applicable
if [[ -f "${SSH_ENV}" ]]; then
  # shellcheck source=/dev/null
  source "${SSH_ENV}" > /dev/null
  cmd=$(ps --no-headers -o command -p "${SSH_AGENT_PID:-}" || true)
  if [[ ! "${cmd}" == "/usr/bin/ssh-agent" ]]; then
    start_agent
  fi
else
  start_agent
fi

unset SSH_ENV
