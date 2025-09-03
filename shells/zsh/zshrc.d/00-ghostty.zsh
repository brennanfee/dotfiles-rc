#!/usr/bin/env zsh

function setup_ghostty() {
  log "Checking if we are running in Ghostty."

  if [[ -z "${GHOSTTY_RESOURCES_DIR}" ]]; then
    log "Shell not running in Ghostty, exiting."
    return 0
  fi

  log "Shell is running in Ghostty."

  if (( ! $+_ghostty_state )); then
    log "Ghostty shell integration not already linked in, adding."
    source_if "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
  else
    log "Ghostty shell integration already linked in."
  fi
}

setup_ghostty
unset -f setup_ghostty
