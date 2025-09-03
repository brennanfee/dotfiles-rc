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

# NeoVim config switcher - This utility allows me to select different Nvim configurations.  Note that this only works with NVim version 0.9.0 and above as it uses the new NVIM_APPNAME feature.

if ! command_exists fzf; then
  return 0
fi

alias nvim-default="nvim"
alias nvim-old="NVIM_APPNAME=nvim-old nvim"
alias nvimo="NVIM_APPNAME=nvim-old nvim"
alias nvim-test="NVIM_APPNAME=nvim-test nvim"
alias nvimt="NVIM_APPNAME=nvim-test nvim"
alias nvim-blank="NVIM_APPNAME=nvim-blank nvim"
alias nvimb="NVIM_APPNAME=nvim-blank nvim"

function nvims() {
  local items=("default" "old" "test" "blank")

  local config="${1:-}"
  if [[ -z ${config} ]]; then
    config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config 󰄾 " --height=50 --layout=reverse --border --exit-0)
    shift
  fi

  if [[ -z ${config} ]]; then
    echo "Nothing selected"
    return 0
  elif [[ ${config} == "default" ]]; then
    nvim "$@"
  else
    NVIM_APPNAME="nvim-${config}" nvim "$@"
  fi
}

function wipe-nvim() {
  items=("default" "old" "test" "blank")

  local config="${1:-}"
  if [[ -z ${config} ]]; then
    config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config 󰄾 " --height=50 --layout=reverse --border --exit-0)
  fi

  if [[ -z ${config} ]]; then
    echo "Nothing selected"
    return 0
  elif [[ ${config} == "default" ]]; then
    echo "Default cannot be wiped"
    return 0
  else
    local folder="nvim-${config}"
    rm -rf "${XDG_CACHE_HOME}/${folder:?}"
    rm -rf "${XDG_DATA_HOME}/${folder:?}"
    rm -rf "${XDG_STATE_HOME}/${folder:?}"
    rm -rf "${XDG_CONFIG_HOME}/${folder:?}"
  fi
}

#bindkey -s ^n "nvims\n" # zsh binding
bind -x '"\C-n": nvims'
