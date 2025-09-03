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

NEOVIM_BIN=""
HAVE_NVIM=0

if command_exists nvim; then
  NEOVIM_BIN=$(which nvim)
  HAVE_NVIM=1
fi

if command_exists nvim-nightly; then
  alias nvim="nvim-nightly"
  NEOVIM_BIN=$(which nvim-nightly)
  HAVE_NVIM=1
fi

if command_exists io.neovim.vim; then
  alias nvim="io.neovim.vim"
  NEOVIM_BIN=$(which io.neovim.vim)
  HAVE_NVIM=1
fi

# if [[ -x ~/Applications/nvim.appimage ]]; then
#   alias nvim="~/Applications/nvim.appimage"
#   NEOVIM_BIN="${HOME}/Applications/nvim.appimage"
#   HAVE_NVIM=1
# fi

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
fi

# For now I don't want to override visual editor with VS Code
# if command_exists code; then
#   export VISUAL='code'
# fi

export EDITOR
export GIT_EDITOR
export SVN_EDITOR
export LESSEDIT
export VISUAL
export IDE="${VISUAL:-${EDITOR:-vim}}"

# Editor mappings
alias e='"$EDITOR"'
alias edit='"$EDITOR"'
alias eg='"$VISUAL"'
alias ev='"$VISUAL"'
alias vis='"$VISUAL"'

unset NEOVIM_BIN
unset HAVE_NVIM
