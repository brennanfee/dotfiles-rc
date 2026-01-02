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

# For other history ideas check out these articles:
#
# https://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history
#
# https://askubuntu.com/questions/80371/bash-history-handling-with-multiple-terminals
#
# https://unix.stackexchange.com/questions/48713/how-can-i-remove-duplicates-in-my-bash-history-preserving-order
#

# Bash options
# Make bash append rather than overwrite the history on disk
shopt -s histappend

# Store multi-line commands in a single history entry
shopt -s cmdhist

# Show a history substitution line rather than directly executing it
shopt -s histverify

# History environment variables
HISTCONTROL="ignoreboth:erasedups"
HISTIGNORE="&:[ ]*:[ \t]*:[fb]g:exit:ls:ls -la:sl:ll:la:lls:lla:pwd:cd:cd -:cdp:cdpp:cdd:cdi:cdt:cdtp"
HISTIGNORE+=":cdm:cdmp:cdv:cdb:cdc:cdx:cdh:cdr:cdw:* --help:* -h:history:history *:man:man *:date"
# HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
HISTFILESIZE=20000
HISTSIZE=10000
HISTFILE="${XDG_STATE_HOME:-$(user_dirs STATE)}/bash_history"

# function historyclean {
#   local previous_exit_status=$?
#   log "calling historyclean"
#   if [[ -e "${HISTFILE}" ]]; then
#     local history_lock
#     exec {history_lock}< ${HISTFILE} && flock -s ${history_lock}
#     # history -w "${HISTFILE}.current.tmp$$"
#     # history -a
#     # # Put current sessions history j
#     # cat "${HISTFILE}" "${HISTFILE}.current.tmp$$" > "${HOSTFILE}.tmp$$"

#     # tac "${HISTFILE}.tmp$$" | awk '! x[$0]++' | tac > "${HISTFILE}.tmp$$"
#     # mv -f "${HISTFILE}.tmp$$" "${HISTFILE}"
#     # history -c
#     # history -r

#     history -n
#     history -w

#     # dedupe
#     tac "${HISTFILE}" | awk '! x[$0]++' | tac > "${HISTFILE}.tmp$$"
#     mv -f "${HISTFILE}.tmp$$" "${HISTFILE}"

#     history -c
#     history -r

#     flock -u ${history_lock}
#   fi
#   return $previous_exit_status
# }

function historyclean {
  local previous_exit_status=$?
  log "calling historyclean"

  history -n
  history -w
  history -c
  history -r

  return $previous_exit_status
}

trap historyclean EXIT

# log "Checking if we need to add historyclean to shell hook"
# if declare -p precmd_functions >/dev/null 2>&1; then
#  log "precmd_functions exists, adding historyclean, if needed"
#  if [[ "${precmd_functions[*]:-}" != *"historyclean"* ]]; then
#    log "Adding historyclean to precmd."
#    precmd_functions+=(historyclean)
#  fi
# else
#  log "precmd_functions does not exist, adding historyclean to PROMPT_COMMAND, if needed"
#  if [[ "${PROMPT_COMMAND[*]:-}" != *"historyclean"* ]]; then
#    log "Adding historyclean to PROMPT_COMMAND."
#    PROMPT_COMMAND+=(historyclean)
#  fi
# fi
