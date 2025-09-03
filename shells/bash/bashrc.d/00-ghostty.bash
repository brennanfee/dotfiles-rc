#!/usr/bin/env bash

### START Sourced Check
sourced=0
if [[ -n "${ZSH_VERSION:-}" ]]; then
  [[ $ZSH_EVAL_CONTEXT =~ :file$ ]] && sourced=1 || sourced=0
elif [[ -n "$BASH_VERSION" ]]; then
  (return 0 2> /dev/null) && sourced=1 || sourced=0
else # All other shells: examine $0 for known shell binary filenames.
  # Detects `sh` and `dash`; add additional shell filenames as needed.
  case ${0##*/} in sh | -sh | dash | -dash) sourced=1 ;; *) sourced=0 ;; esac
fi

if [[ ${sourced} -eq 0 ]]; then
  echo "This script should only be sourced, never called directly." >&2
  exit 1
fi
unset sourced
### END Sourced Check

function setup_ghostty() {
  log "Checking if we are running in Ghostty."

  if [[ -z "${GHOSTTY_RESOURCES_DIR}" ]]; then
    log "Shell not running in Ghostty, exiting."
    return 0
  fi

  log "Shell is running in Ghostty."

  # log "Shell is running in Ghostty, hooking in shell integration (if needed)."

  if [[ -z ${bash_preexec_imported:-} ]]; then
    log "Ghostty shell integration not already linked in, adding."
    source_if "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
  else
    log "Ghostty shell integration already linked in."
  fi
}

setup_ghostty
unset -f setup_ghostty
