#!/usr/bin/env zsh

function setup_editors {
  local neovim_bin have_nvim

  if command_exists nvim; then
    neovim_bin=$(which nvim)
    have_nvim=1
  fi

  if command_exists nvim-nightly; then
    alias nvim="nvim-nightly"
    neovim_bin=$(which nvim-nightly)
    have_nvim=1
  fi

  if command_exists io.neovim.vim; then
    alias nvim="io.neovim.vim"
    neovim_bin=$(which io.neovim.vim)
    have_nvim=1
  fi

  if [[ ${HAVE_NVIM} == "1" ]]; then
    # Setup for nvim
    alias vi='"${NEOVIM_BIN}"'
    alias vim='"${NEOVIM_BIN}"'
    alias ogvim="/usr/bin/vim"
    alias realvim="/usr/bin/vim"
    alias v='"${NEOVIM_BIN}" -R'
    alias view='"${NEOVIM_BIN}" -R'

    EDITOR="${NEOVIM_BIN}"
    GIT_EDITOR="${NEOVIM_BIN}"
    SVN_EDITOR="${NEOVIM_BIN}"
    LESSEDIT="${NEOVIM_BIN}"

    VISUAL="${NEOVIM_BIN}"
    IDE="${VISUAL:-${EDITOR:-${NEOVIM_BIN}}}"
  else
    # Setup for vim
    alias vi="vim"
    alias ogvim="/usr/bin/vim"
    alias realvim="/usr/bin/vim"
    alias v="vim -R"
    alias view="vim -R"

    EDITOR='vim'
    GIT_EDITOR='vim'
    SVN_EDITOR='vim'
    LESSEDIT='vim'

    if command_exists gvim; then
      VISUAL='gvim'
    else
      VISUAL='vim'
    fi

    IDE="${VISUAL:-${EDITOR:-vim}}"
  fi

  export EDITOR
  export GIT_EDITOR
  export SVN_EDITOR
  export LESSEDIT
  export VISUAL
  export IDE

  # Editor mappings
  alias e='"$EDITOR"'
  alias edit='"$EDITOR"'
  alias eg='"$VISUAL"'
  alias ev='"$VISUAL"'
  alias vis='"$VISUAL"'
  alias ide='"$IDE"'
}

setup_editors
unset -f setup_editors
