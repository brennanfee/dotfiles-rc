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

function _custom_prompt {
  local last_exit=$?

  PS1="${text_reset}\n${text_green}\u@\h ${text_magenta}\w   ${text_red}(Starship is not installed) ${text_reset}\n\$ "

  return ${last_exit}
}

function setup_custom_prompt {
  export PROMPT_DIRTRIM=4

  if [[ -n "${bash_preexec_imported:-}" ]]; then
    log "prompt pre-exec branch"
    if [[ "${precmd_functions[*]:-}" != *"_custom_prompt"* ]]; then
      precmd_functions+=(_custom_prompt)
    fi
  else
    log "prompt command branch"
    local regex_pattern="^declare -a PROMPT_COMMAND($|=)"
    local cur_prompt
    cur_prompt=$(declare -p PROMPT_COMMAND 2> /dev/null)
    log "prompt cur_prompt: ${cur_prompt}"
    if [[ "${cur_prompt}" =~ $regex_pattern ]]; then
      if [[ ${PROMPT_COMMAND[*]:-} != *"_custom_prompt"* ]]; then
        PROMPT_COMMAND+=(_custom_prompt)
      fi
    else
      if [[ ";${PROMPT_COMMAND:-};" != *";_custom_prompt;"* ]]; then
        # shellcheck disable=SC2128,SC2178
        PROMPT_COMMAND="_custom_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
      fi
    fi

    cur_prompt=$(declare -p PROMPT_COMMAND 2> /dev/null)
    log "prompt after_prompt: ${cur_prompt}"
  fi
}

function setup_prompt {
  if command_exists starship; then
    log "setting up starship for prompt"
    eval "$(starship init bash)"
  else
    setup_custom_prompt
  fi

  # setup_custom_prompt
}

setup_prompt
unset -f setup_custom_prompt
unset -f setup_prompt
