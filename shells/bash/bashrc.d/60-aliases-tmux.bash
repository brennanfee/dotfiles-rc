#!/usr/bin/env bash

### START Bash strict mode for library
sourced=0
if [[ -n "${ZSH_VERSION:-}" ]]; then
  [[ ${ZSH_EVAL_CONTEXT:-} =~ :file$ ]] && sourced=1 || sourced=0
elif [[ -n "${BASH_VERSION:-}" ]]; then
  (return 0 2> /dev/null) && sourced=1 || sourced=0
else # All other shells: examine $0 for known shell binary filenames.
  # Detects `sh` and `dash`; add additional shell filenames as needed.
  case ${0##*/} in sh | -sh | dash | -dash) sourced=1 ;; *) sourced=0 ;; esac
fi
if [[ "${sourced}" -ne 1 ]]; then
  echo "This script is intended to be sourced, not called directly or executed." >&2
  exit 1
fi
unset sourced
### END Bash strict mode for library

function tmux_first_window() {
  local window
  window=$(tmux list-windows -F "#{window_id}" | head -n 1)
  tmux select-window -t "${window}"
}

function tmux_last_window() {
  local window
  window=$(tmux list-windows -F "#{window_id}" | tail -n 1)
  tmux select-window -t "${window}"
}

if command_exist tmux; then
  ## Session Management
  alias tmls="tmux list-sessions"
  alias tmko="tmux kill-session -a"
  alias tmnuke="tmux kill-server"

  ## Window movement
  alias tmn="tmux next-window"
  alias tmp="tmux previous-window"
  alias tmt="tmux last-window"
  alias tmf="tmux_first_window"
  alias tm0="tmux_first_window"
  alias tml="tmux_last_window"
  alias tm99="tmux_last_window"

  alias tm1="tmux select-window -t 1"
  alias tm2="tmux select-window -t 2"
  alias tm3="tmux select-window -t 3"
  alias tm4="tmux select-window -t 4"
  alias tm5="tmux select-window -t 5"
  alias tm6="tmux select-window -t 6"
  alias tm7="tmux select-window -t 7"
  alias tm8="tmux select-window -t 8"
  alias tm9="tmux select-window -t 9"
fi
