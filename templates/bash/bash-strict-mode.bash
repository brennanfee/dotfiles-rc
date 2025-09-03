#!/usr/bin/env bash

### START Bash strict mode
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
  set -o errexit  # same as set -e
  set -o nounset  # same as set -u
  set -o errtrace # same as set -E
  set -o pipefail
  set -o posix
  #set -o xtrace # same as set -x, turn on for debugging

  shopt -s extdebug
  IFS=$(printf '\n\t')
fi
unset sourced
### END Bash strict mode

###################################################################################################
### START Script template bootstrap

function load_base_functions() {
  local functions_script="${USER_DIRS_DOTFILES:-${HOME}/.dotfiles-rc}/shells/shared/base-functions.bash"

  if [[ -f "${functions_script}" ]]; then
    # shellcheck source=/home/brennan/.dotfiles-rc/shells/shared/base-functions.bash
    builtin source "${functions_script}"
  fi
}

function main() {
  true
}

## This must be the last line
main "$@"
