#!/bin/zsh
##? .zshrc - Run on interactive Zsh session.

function log_rc {
  if [[ ${ZSHRC_LOGS:-0} -eq 1 ]]; then
    local log_file stamp
    log_file="${USER_DIRS_PROFILE:-${HOME}/profile}/zshrc.log"
    stamp="$(/usr/bin/date '+%F %I:%M:%S.%N %p')"

    echo -e "${stamp}: $1" >>"${log_file}"
  fi
}

function reset_path {
  log_rc "Resetting path to shell defaults..."
  if [[ -n "${ZSH_STARTUP_PATH:-}" ]]; then
    PATH="${ZSH_STARTUP_PATH}"
  else
    export ZSH_STARTUP_PATH="${PATH}"
  fi
  log_rc "Path after reset: ${PATH}"
}

function check_launch_tmux {
  log_rc "Checking if we need to launch tmux. TERM: '${TERM}'"
  if command -v tmux &>/dev/null && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] &&
    [[ ! "$TERM" =~ dumb ]] && [ -z "$TMUX" ]; then

    log_rc "Launching tmux"
    exec tmux
    # exec tmux new-session -A -s main
  else
    log_rc "Skipping launch of tmux, already launched."
  fi
}

function load_base_functions {
  log_rc "Loading base functions script"
  local functions_script

  # Load my base-functions to have access to all my shell helper methods and functions
  #
  # The base-profile should have already been loaded by .zprofile, so in theory we should be able
  # to just use the USER_DIRS_DOTFILES environment variable without worry. However, we want to guard
  # against the edge case where for whatever reason the profile has not yet been loaded.  As such,
  # we are leveraging the fact that we, at the very minimum, have set the ZDOTDIR at this point
  # and that the ZDOTDIR sits WITHIN the dotfiles directory tree. This should be the only place
  # where this is necessary. After the base-profile and base-functions are loaded other
  # scripts\code locations should be able to just directly use the environment variables or my
  # user_dirs utility to find locations.
  functions_script="$(realpath -m "${ZDOTDIR}/../shared/base-functions.bash")"

  if [[ -f "${functions_script}" ]]; then
    log_rc "Sourcing: ${functions_script}"
    # shellcheck source=/home/brennan/.dotfiles-rc/shells/shared/base-functions.bash
    builtin source "${functions_script}"
  fi
}

function setup_completions {
  mkdir -p "${XDG_CACHE_HOME}/zsh/completions"
  fpath=("${XDG_CACHE_HOME}/zsh/completions" $fpath)
  typeset -gU fpath

  # autoload -U compinit
  # zmodload zsh/complist
  # _comp_options+=(globdots) # With hidden files
  # compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
}

# function autoload_functions {
#   log_rc "Setting up functions for autoload"
#   local zfuncdir
#   zfuncdir="${ZDOTDIR}"/zfunctions
#   fpath=($zfuncdir $fpath)
#   typeset -gU fpath

#   # autoload -Uz $zfuncdir/*(.:t)
# }

function source_zstyles {
  log_rc "Load zstyles if present"
  source_if "${ZDOTDIR}/zstyles"
}

function load_plugins {
  log_rc "Loading plugins"

  log_rc "Checking if antidote is already installed"

  local antidote_root="${XDG_CACHE_HOME}/zsh"

  if [[ ! -d "${antidote_root}/antidote" ]]; then
    log_rc "Antidote missing, cloning."
    mkdir -p "${antidote_root}"
    git clone --depth=1 https://github.com/mattmc3/antidote "${antidote_root}/antidote"
  fi

  source_if "${antidote_root}/antidote/antidote.zsh"

  log_rc "Loading antidote and plugins"
  antidote load "${ZDOTDIR}/zplugins"
}

function source_zshrc_d_files {
  log_rc "Sourcing zshrc.d files"
  local file
  for file in "${ZDOTDIR}"/zshrc.d/*.zsh; do
    # Ignore tilde files
    if [[ $file:t != '~'* ]]; then
      source_if "${file}"
    fi
  done
}

function source_host_zshrc {
  log_rc "Loading local zshrc if present"
  source_if "${HOME}/.zshrc_host"
}

function source_local_zshrc {
  log_rc "Loading local zshrc if present"
  source_if "${HOME}/.zshrc_local"
}

function run_colorscripts {
  if command_exists colorscripts; then
    log_rc "Running colorscripts"
    colorscripts banners random
  fi
}

function log_duration_results {
  if command_exists bc; then
    local end runtime
    end=$(date +%s.%N)
    runtime=$(echo "${end} - ${1}" | bc -l)

    log_rc "Zshrc duration: ${runtime} seconds"
    print_out "Zshrc duration: ${runtime} seconds"
  fi
}

function zshrc {
  local start
  start=$(date +%s.%N)
  log_rc "------------------------------ START ZSHRC ------------------------------"
  log_rc "In zshrc"
  log_rc "Startup ZDOTDIR: ${ZDOTDIR}"
  log_rc "Startup PATH: ${PATH}"
  log_rc "Base profile loaded: ${BASE_PROFILE_LOADED:-0}"
  if [[ -o login ]]; then log_rc 'Login shell'; else log_rc 'Non-login shell'; fi
  if [[ -o interactive ]]; then log_rc 'Interactive shell'; else log_rc 'Non-interactive shell'; fi

  reset_path
  check_launch_tmux

  load_base_functions

  setup_completions

  # autoload_functions
  source_zstyles
  source_zshrc_d_files
  load_plugins

  source_host_zshrc
  source_local_zshrc

  # NOTE: TEMPORARY, here just for livability while I weave in all my shell settings
  alias cdt="cd ~/.dotfiles-rc"
  alias e="nvim"
  alias ytp='${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}/bin/yt-dlp-helper ytp'

  run_colorscripts

  log_rc "Final path: ${PATH}"
  log_duration_results "${start}"
  log_rc "Leaving zshrc"
}

zshrc "$@"
unset -f log_rc
unset -f reset_path
unset -f check_launch_tmux
unset -f load_base_functions
unset -f setup_completions
# unset -f autoload_functions
unset -f source_zstyles
unset -f load_plugins
unset -f source_zshrc_d_files
unset -f source_host_zshrc
unset -f source_local_zshrc
unset -f run_colorscripts
unset -f log_duration_results
unset -f zshrc

# Load zprof first if we need to profile.
# [[ ${ZPROFRC:-0} -eq 0 ]] || zmodload zsh/zprof
# alias zprofrc="ZPROFRC=1 zsh"

# Load P10 instaprompt next.
# [[ ${ZPROFRC:-0} -eq 0 ]] || typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Load zstyles.
# [[ -f $ZDOTDIR/zstyles ]] && source $ZDOTDIR/zstyles

# Clone antidote if necessary.
# [[ -e $ZDOTDIR/.antidote ]] ||
#   git clone --depth=1 https://github.com/mattmc3/antidote.git $ZDOTDIR/.antidote

# # Setup antidote plugins.
# ANTIDOTE_HOME=$ZDOTDIR/.antidote/.plugins
# source $ZDOTDIR/.antidote/antidote.zsh
# antidote load

# Local settings/overrides.
# [[ -f $ZDOTDIR/zshrc_local ]] && $ZDOTDIR/zshrc_local

# Done profiling.
# [[ ${ZPROFRC:-0} -eq 0 ]] || { unset ZPROFRC && zprof }
# true

# # Lines configured by zsh-newuser-install
# HISTFILE=~/.cache/zsh/histfile
# HISTSIZE=10000
# SAVEHIST=10000
# setopt appendhistory autocd beep extendedglob nomatch
# unsetopt notify
# bindkey -v
# # End of lines configured by zsh-newuser-install
# # The following lines were added by compinstall
# zstyle :compinstall filename '/home/brennan/.zshrc'

# autoload -Uz compinit
# compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION-$HOSTNAME
# # End of lines added by compinstall
