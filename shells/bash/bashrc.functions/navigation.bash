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

# Some quick navigations within my profile path, largely managed by
# my custom user_dirs system (which is an extension\clone of xdg-user-dir).

# Helper functions the others will use
function xdg-cd-sub() {
  # $1 = xdg name for path, required
  # $2 = backup path if xdg name not found, required
  # $3 = direct sub-path to navigate to, required
  # $4 = alternate spelling/casing of sub-path to naviate to, required
  # $5 = sub-path to go to if it exists, optional

  local the_path
  local sub1
  local sub2

  the_path=$(user_dirs "$1")
  the_path="${the_path:-$2}"

  if [[ -d "${the_path}" ]]; then
    sub1="${the_path}/${3}"
    sub2="${the_path}/${4}"
    if [[ -d "${sub1}" ]]; then
      the_path="${sub1}"
    elif [[ -d "${sub2}" ]]; then
      the_path="${sub2}"
    else
      builtin cd "${the_path}" || return
    fi

    if [[ "${5:-}" != "" && -d "${the_path}/${5}" ]]; then
      builtin cd "${the_path}/${5}" || return
    else
      builtin cd "${the_path}" || return
    fi
  else
    cdp # The xdg path doesn't exist
  fi
}

function xdg-go-to-dir() {
  # $1 = xdg name for path, required
  # $2 = backup path if xdg name not found, required
  # $3 = sub-path to go to if it exists, optional
  local the_path
  the_path=$(user_dirs "$1")
  the_path="${the_path:-$2}"

  if [[ -d "${the_path}" ]]; then
    if [[ "${3:-}" != "" && -d "${the_path}/${3}" ]]; then
      builtin cd "${the_path}/${3}" || return
    else
      builtin cd "${the_path}" || return
    fi
  else
    cdp ""
  fi
}

# Profile folder
function cdp() {
  # $1 = sub-path to go to if it exists, optional

  local the_path
  the_path="${USER_DIRS_PROFILE:-$(user_dirs "PROFILE")}"
  the_path="${the_path:-${HOME}/profile}"

  if [[ -d "${the_path}" ]]; then
    if [[ "${1:-}" != "" && -d "${the_path}/${1}" ]]; then
      builtin cd "${the_path}/${1}" || return
    else
      builtin cd "${the_path}" || return
    fi
  else
    builtin cd "${HOME}" || return
  fi
}

# Desktop folder
function cdsk() {
  xdg-go-to-dir "DESKTOP" "${HOME}/Desktop" "${1:-}"
}
#alias cdk=cdsk

# Templates folder
function cdtm() {
  xdg-go-to-dir "TEMPLATES" "${PROFILEPATH}/templates" "${1:-}"
}

# Source folder
function cds() {
  xdg-go-to-dir "SOURCE" "${PROFILEPATH}/source" "${1:-}"
}

# Personal source folder (usually only there on my work machines)
function cdsp() {
  xdg-cd-sub "SOURCE" "${PROFILEPATH}/source" "personal" "Personal" "${1:-}"
}
alias cdss=cdsp

# Work source folder (usually only there on my personal machines, and not frequently)
function cdsw() {
  xdg-cd-sub "SOURCE" "${PROFILEPATH}/source" "work" "Work" "${1:-}"
}

# Github source folder (source projects I pull directly from Github)
# In truth this is also where I pull BitBucket or GitLab public projects
function cdsg() {
  xdg-cd-sub "SOURCE" "${PROFILEPATH}/source" "github" "Github" "${1:-}"
}

# Downloads folder
function cdd() {
  xdg-go-to-dir "DOWNLOAD" "${PROFILEPATH}/downloads" "${1:-}"
}

# Install folder
function cdi() {
  xdg-go-to-dir "INSTALLS" "$PROFILEPATH/installs" "${1:-}"
}

# Dotfiles folder
function cdt() {
  xdg-go-to-dir "DOTFILES" "${HOME}/.dotfiles-rc" "${1:-}"
}

# Private dotfiles folder
function cdtp() {
  xdg-go-to-dir "DOTFILESPRIVATE" "${HOME}/.dotfiles-private" "${1:-}"
}

# Dotfiles bin
function cdtb() {
  xdg-cd-sub "DOTFILES" "${HOME}/.dotfiles-rc" "bin" "bin" "${1:-}"
}

# User Bin folder
function cdlb() {
  xdg-go-to-dir "BIN" "${HOME}/.local/bin" "${1:-}"
}
alias cdb=cdlb

# Music folder
function cdm() {
  xdg-go-to-dir "MUSIC" "${PROFILEPATH}/music" "${1:-}"
}

# Music playlist folder
function cdmp() {
  xdg-cd-sub "MUSIC" "${PROFILEPATH}/music" "playlists" "Playlists" "${1:-}"
}
alias cdpl="cdmp"

# Mounts folder
function cdmt() {
  xdg-go-to-dir "MOUNTS" "${HOME}/mounts" "${1:-}"
}

# Mount "files"
function cdmf() {
  xdg-cd-sub "MOUNTS" "${HOME}/mounts" "files" "files" "${1:-}"
}

# Mount "other"
function cdmo() {
  xdg-cd-sub "MOUNTS" "${HOME}/mounts" "other" "other" "${1:-}"
}

# Mount "backups"
function cdmb() {
  xdg-cd-sub "MOUNTS" "${HOME}/mounts" "backups" "backups" "${1:-}"
}

# Videos folder
function cdv() {
  xdg-go-to-dir "VIDEOS" "${PROFILEPATH}/videos" "${1:-}"
}

# VMs folder
function cdvm() {
  xdg-go-to-dir "VMS" "${PROFILEPATH}/vms" "${1:-}"
}

# Cloud folder, intended as the cloud shared\synced folder
function cdc() {
  xdg-go-to-dir "CLOUD" "${PROFILEPATH}/cloud/files" "${1:-}"
}

# Obsidian notes folder which is stored in the cloud folder...
function cdn() {
  if [[ "${1:-}" != "" ]]; then
    cdc "notes/brain/${1}"
  else
    cdc "notes/brain"
  fi
}

# Goto just the notes folder, this is for other synced notes not managed by obsidian
function cdnn() {
  if [[ "${1:-}" != "" ]]; then
    cdc "notes/${1}"
  else
    cdc "notes"
  fi
}

# Documents or "My Documents"
function cdoc() {
  xdg-go-to-dir "DOCUMENTS" "${PROFILEPATH}/documents" "${1:-}"
}
alias cdo=cdoc

# Pictures or Photos
function cdx() {
  xdg-go-to-dir "PICTURES" "${PROFILEPATH}/pictures" "${1:-}"
}
alias cdpx=cdx

# Home alias, some linux systems require typing "cd -" to go home.  This replaces that.
function cdh() {
  xdg-go-to-dir "HOME" "${HOME}" "${1:-}"
}

# "Alternate" home, or Windows home - will only be different from $HOME on Windows
function cdhh() {
  if [[ "${WIN_HOME:-}" != "" && -d ${WIN_HOME} ]]; then
    builtin cd "${WIN_HOME}" || return
  else
    builtin cd "${HOME}" || return
  fi
}
alias cdwh=cdhh

# Jump to the "winfiles"... otherwise "dotfiles"
function cdw() {
  if [[ -d ${PROFILEPATH} && -d "${PROFILEPATH}/winfiles" ]]; then
    builtin cd "${PROFILEPATH}/winfiles" || return
  else
    cdt ""
  fi
}

# The root of the current git project
alias cdr="cd-to-git-root-path"

# Fuzzy find a directory
function cdf() {
  if command_exists fzf; then
    eval "$(__fzf_cd__ || true)"
  else
    builtin cd "$@"
  fi
}
