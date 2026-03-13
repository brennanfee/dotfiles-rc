#!/usr/bin/env bash

function main() {
  local side="all"
  if [[ "${1:-}" == "1" || "${1:-}" == "l" || "${1:-}" = "left" ]]; then
    side="left"
  fi
  if [[ "${1:-}" == "2" || "${1:-}" == "r" || "${1:-}" = "right" ]]; then
    side="right"
  fi

  if [[ "${side}" == "left" || "${side}" == "all" ]]; then
    xrandr --output HDMI-A-0 --off

    xrandr --output HDMI-A-0 --primary --mode 3840x2160 --left-of DisplayPort-1
  fi

  if [[ "${side}" == "right" || "${side}" == "all" ]]; then
    xrandr --output DisplayPort-1 --off

    xrandr --output DisplayPort-1 --mode 3840x2160 --right-of HDMI-A-0
  fi
}

## This must be the last line
main "$@"
