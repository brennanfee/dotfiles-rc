#!/usr/bin/env bash

main() {
  local lockfile="$HOME/.var/app/org.qbittorrent.qBittorrent/config/qBittorrent/lockfile"
  if [[ -f "$lockfile" ]]; then
    rm "$lockfile"
  fi
}

## This must be the last line
main "$@"
