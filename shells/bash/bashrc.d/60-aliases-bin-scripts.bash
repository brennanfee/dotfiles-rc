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

dotfiles="${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}"

# Aliases to scripts in my dotfiles bin folder

if [[ -x "${dotfiles}/bin/tmux-current-session" ]]; then
  alias tcs='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-current-session'
fi

if [[ -x "${dotfiles}/bin/tmux-window-switch" ]]; then
  alias tws='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch'
  alias twt='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch t'
  alias twf='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch f'
  alias twl='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch l'
  alias twp='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch p'
  alias twn='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch n'
  alias tw1='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch 1'
  alias tw2='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch 2'
  alias tw3='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch 3'
  alias tw4='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch 4'
  alias tw5='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch 5'
  alias tw6='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch 6'
  alias tw7='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch 7'
  alias tw8='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch 8'
  alias tw9='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/tmux-window-switch 9'
fi

if [[ -x "${dotfiles}/bin/do-update" ]]; then
  alias doup='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/do-update'
fi

if [[ -x "${dotfiles}/bin/yt-dlp-helper" ]]; then
  alias yt='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/yt-dlp-helper yt'
  alias ytl='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/yt-dlp-helper ytl'
  alias ytm='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/yt-dlp-helper ytm'
  alias ytml='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/yt-dlp-helper ytml'
  alias ytp='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/yt-dlp-helper ytp'
  alias ytpl='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/yt-dlp-helper ytpl'
fi

if [[ -x "${dotfiles}/bin/ssh-tools" ]]; then
  alias ssh-list='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/ssh-tools list'
fi

if [[ -x "${dotfiles}/bin/wolf" ]]; then
  alias wolf='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/wolf imperial'
  alias wolfi='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/wolf imperial'
  alias wolfm='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/wolf metric'
fi

if [[ -x "${dotfiles}/bin/cheat" ]]; then
  alias cheat='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/cheat cheat'
  alias tldr='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/cheat tldr'
  alias chsht='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/cheat chsh'
fi

unset dotfiles
