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

function setup_uv {
  # Export these regardless of whether uv is found, that way if uv is activated or used later
  # the settings will still be in place
  export INSTALLER_NO_MODIFY_PATH=1
  export UV_SYSTEM_CERTS="true"
  export UV_PYTHON_PREFERENCE="only-managed"

  if command -v uv &> /dev/null; then
    eval "$(uv generate-shell-completion bash)"

    alias uvr="uv run"
  fi

  if command -v uvx &> /dev/null; then
    eval "$(uvx --generate-shell-completion bash)"
  fi
}

setup_uv "#@"
unset -f setup_uv
