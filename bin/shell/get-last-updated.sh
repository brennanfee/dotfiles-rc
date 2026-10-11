#!/usr/bin/env sh

# POSIX strict mode (may produce issues in sourced scenarios)
set -o errexit
set -o nounset
#set -o xtrace # same as set -x, turn on for debugging

IFS=$(printf '\n\t')
# END POSIX strict mode

main() {
  update_log_file="${XDG_CACHE_HOME:-$HOME/.cache}/updates.log"

  if [ -f "${update_log_file}" ]; then
    tail -n 1 "${update_log_file}"
  else
    echo "unknown"
  fi
}

main "$@"
