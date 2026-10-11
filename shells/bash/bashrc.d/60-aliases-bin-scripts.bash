#!/usr/bin/env bash

# Bash strict mode
# shellcheck disable=SC2154,SC2139
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

dotfiles="${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}"

# Special aliases to scripts in my dotfiles bin folder (and immediate sub-folders)

shopt -s globstar

for file in "${dotfiles}"/bin/**/*.{sh,bash}; do
  if [[ -f "${file}" ]]; then
    the_alias="$(basename "${file%.*}")"
    the_file="$(realpath "${file}")"

    alias "${the_alias}"="${the_file}"
  fi
done

# Need to do python separate as we only want the direct files under in the python folder (sub-folders would be modules)
for file in "${dotfiles}"/bin/python/*.py; do
  if [[ -f "${file}" ]]; then
    the_alias="$(basename "${file%.*}")"
    the_file="$(realpath "${file}")"

    alias "${the_alias}"="${the_file}"
  fi
done

# Special aliases to a few of the scripts

if [[ -x "${dotfiles}/bin/bash/tmux-current-session.bash" ]]; then
  the_file="$(realpath "${dotfiles}/bin/bash/tmux-current-session.bash")"
  alias tcs="${the_file}"
fi

if [[ -x "${dotfiles}/bin/bash/tmux-window-switch.bash" ]]; then
  the_file="$(realpath "${dotfiles}/bin/bash/tmux-window-switch.bash")"
  alias tws="${the_file}"
  alias twt="${the_file} t"
  alias twf="${the_file} f"
  alias twl="${the_file} l"
  alias twp="${the_file} p"
  alias twn="${the_file} n"
  alias tw1="${the_file} 1"
  alias tw2="${the_file} 2"
  alias tw3="${the_file} 3"
  alias tw4="${the_file} 4"
  alias tw5="${the_file} 5"
  alias tw6="${the_file} 6"
  alias tw7="${the_file} 7"
  alias tw8="${the_file} 8"
  alias tw9="${the_file} 9"
fi

if [[ -x "${dotfiles}/bin/bash/do-update.bash" ]]; then
  the_file="$(realpath "${dotfiles}/bin/bash/do-update.bash")"
  alias doup="${the_file}"
fi

if [[ -x "${dotfiles}/bin/bash/yt-dlp-helper.bash" ]]; then
  the_file="$(realpath "${dotfiles}/bin/bash/yt-dlp-helper.bash")"
  alias yt="${the_file} yt"
  alias yth="${the_file} yth"
  alias ytl="${the_file} ytl"
  alias ytlh="${the_file} ytlh"
  alias ytm="${the_file} ytm"
  alias ytml="${the_file} ytml"
  alias ytp="${the_file} ytp"
  alias ytph="${the_file} ytph"
  alias ytpl="${the_file} ytpl"
  alias ytplh="${the_file} ytplh"
fi

if [[ -x "${dotfiles}/bin/bash/ssh-tools.bash" ]]; then
  the_file="$(realpath "${dotfiles}/bin/bash/ssh-tools.bash")"
  alias ssh-list="${the_file} list"
fi

if [[ -x "${dotfiles}/bin/bash/wolf.bash" ]]; then
  the_file="$(realpath "${dotfiles}/bin/bash/wolf.bash")"
  alias wolf="${the_file} imperial"
  alias wolfi="${the_file} imperial"
  alias wolfm="${the_file} metric"
fi

if [[ -x "${dotfiles}/bin/bash/cheat.bash" ]]; then
  the_file="$(realpath "${dotfiles}/bin/bash/cheat.bash")"
  alias cheat="${the_file} cheat"
  alias tldr="${the_file} tldr"
  alias chsht="${the_file} chsh"
fi

if [[ -x "${dotfiles}/bin/bash/colorscripts.bash" ]]; then
  the_file="$(realpath "${dotfiles}/bin/bash/colorscripts.bash")"
  alias colortest="${the_file} tests"
fi
