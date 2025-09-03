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

if command_exists com.bitwarden.desktop; then
  alias bitwarden="com.bitwarden.desktop"
fi

if command_exists com.jgraph.draw.io.desktop; then
  alias drawio="com.jgraph.draw.io.desktop"
fi

if command_exists com.spotify.Client; then
  alias spotify="com.spotify.Client"
fi

if command_exists org.libreoffice.LibreOffice; then
  alias libreoffice="org.libreoffice.LibreOffice"
fi

if command_exists org.mozilla.firefox; then
  alias firefox="org.mozilla.firefox"
fi

if command_exists org.signal.Signal; then
  alias signal="org.signal.Signal"
fi

if command_exists org.speedcrunch.SpeedCrunch; then
  alias speedcrunch="org.speedcrunch.SpeedCrunch"
  alias sc="org.speedcrunch.SpeedCrunch"
fi

if command_exists org.videolan.VLC; then
  alias vlc="org.videolan.VLC"
fi

if command_exists org.wezfurlong.wezterm; then
  alias wezterm="org.wezfurlong.wezterm"
fi

if command_exists org.gnu.emacs; then
  alias emacs="org.gnu.emacs"
fi

if command_exists com.slack.Slack; then
  alias slack="com.slack.Slack"
fi

if command_exists io.github.zyedidia.micro; then
  alias micro="io.github.zyedidia.micro"
fi

if command_exists com.github.tenderowl.frog; then
  alias frog="com.github.tenderowl.frog"
fi

if command_exists com.plexamp.Plexamp; then
  alias plexamp="com.plexamp.Plexamp"
fi

if command_exists com.rafaelmardojai.Blanket; then
  alias blanket="com.rafaelmardojai.Blanket"
fi

if command_exists org.ferdium.Ferdium; then
  alias ferdium="org.ferdium.Ferdium"
fi

if command_exists tv.plex.PlexDesktop; then
  alias plex="tv.plex.PlexDesktop"
fi

if command_exists tv.plex.PlexHTPC; then
  alias plexhtpc="tv.plex.PlexHTPC"
fi
