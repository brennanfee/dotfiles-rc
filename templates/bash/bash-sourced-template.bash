#!/usr/bin/env bash

### START Sourced Check
sourced=0
if [[ -n "${ZSH_VERSION:-}" ]]; then
  [[ ${ZSH_EVAL_CONTEXT:-} =~ :file$ ]] && sourced=1 || sourced=0
elif [[ -n "${BASH_VERSION:-}" ]]; then
  (return 0 2> /dev/null) && sourced=1 || sourced=0
else # All other shells: examine $0 for known shell binary filenames.
  # Detects `sh` and `dash`; add additional shell filenames as needed.
  case ${0##*/} in sh | -sh | dash | -dash) sourced=1 ;; *) sourced=0 ;; esac
fi

if [[ ${sourced} -ne 1 ]]; then
  echo "This script should only be sourced, never called directly." >&2
  exit 1
fi
unset sourced
### END Sourced Check
