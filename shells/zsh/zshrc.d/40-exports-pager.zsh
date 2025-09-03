#!/usr/bin/env zsh

function setup_pager {
  export PAGER="less"
  export LESSHISTFILE="${XDG_CACHE_HOME:-$(user_dirs CACHE)}/lesshst"

  if command_exists bat; then
    export BAT_BIN="bat"
    alias cat="bat"
    alias batcat="bat"
    alias catp="cat -P"
  elif command_exists batcat; then
    export BAT_BIN="batcat"
    alias cat="batcat"
    alias bat="batcat"
    alias catp="cat -P"
  else
    export BAT_BIN="cat"
    alias bat="cat"
    alias batcat="cat"
    alias catp="cat"
  fi

  if [[ "${BAT_BIN}" == "bat" || "${BAT_BIN}" == "batcat" ]]; then
    # Completions
    mkdir -p "${XDG_CACHE_HOME}/zsh/completions"
    "${BAT_BIN}" --completion zsh > "${XDG_CACHE_HOME}/zsh/completions/bat-completions.zsh"

    # Augment rg
    if command_exists rg; then
      function batrg() {
        rg -S -p "$@" | less -R
      }
      function batgrep() {
        rg -S -p "$@" | less -R
      }
    else
      function batgrep() {
        grep "$@" | less
      }
    fi
  fi

  # Setup manpager
  if [[ "${EDITOR}" == "nvim" ]]; then
    export MANPAGER="nvim +Man!"
  elif [[ "${BAT_BIN}" == "bat" || "${BAT_BIN}" == "batcat" ]]; then
    export MANROFFOPT="-c"

    if [[ -x "${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/scripts/batpipe" ]]; then
      eval "$("${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/scripts/batpipe")"
      export MANPAGER="less -R --use-color -Dd+r -Du+b"
    else
      export MANPAGER="sh -c 'col -bx | batcat -l man'"
    fi
  else
    export LESS="--LINE-NUMBERS --quit-if-one-screen --ignore-case --RAW-CONTROL-CHARS --tabs=2 --use-color --QUIET --LONG-PROMPT --mouse"
    export MANPAGER="less --no-lessopen --line-numbers"
  fi
}

setup_pager
unset -f setup_pager
