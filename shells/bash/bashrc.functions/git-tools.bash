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

shopt -s inherit_errexit

function git-branch-name() {
  local res=in-a-git-repo
  if [[ res -eq 0 ]]; then
    git rev-parse --abbrev-ref HEAD
  else
    echo "Not a git repo."
  fi
}

function in-a-git-repo() {
  get_exit_code git rev-parse --is-inside-work-tree > /dev/null 2>&1
  if [[ ${EXIT_CODE} -eq 0 ]]; then
    return 0
  else
    return 1
  fi
}

function git-root-path() {
  local res=in-a-git-repo
  if [[ res -eq 0 ]]; then
    git rev-parse --show-toplevel
  else
    pwd
  fi
}

function cd-to-git-root-path() {
  local res=in-a-git-repo
  if [[ res -eq 0 ]]; then
    if [[ -n $1 ]]; then
      cd "$(git rev-parse --show-cdup || true)/$1" || return
    else
      cd "$(git rev-parse --show-cdup || true)" || return
    fi
  fi
}

function git-get-remote-user() {
  local remote="origin"
  if [[ -n $1 ]]; then
    remote=$1
  fi

  local res=in-a-git-repo
  if [[ res -eq 0 ]]; then
    git remote get-url "${remote}" | sed -E 's@^.+(:|/)([^/]+)/.+$@\2@'
  else
    echo ""
  fi
}

function git-get-remote-name() {
  local remote="origin"
  if [[ -n $1 ]]; then
    remote=$1
  fi

  local res=in-a-git-repo
  if [[ res -eq 0 ]]; then
    git remote get-url "${remote}" | sed -E 's@^.+[:/][^/]+.+/([^.]+)(.git)?$@\1@'
  else
    echo ""
  fi
}

function git-get-remote-protocol() {
  local remote="origin"
  if [[ -n $1 ]]; then
    remote=$1
  fi

  local res=in-a-git-repo
  if [[ res -eq 0 ]]; then
    git remote get-url "${remote}" | sed -E 's@^(git|ssh|https)[\@:+].+$@\1@'
  else
    echo ""
  fi
}

function git-get-remote-service() {
  local remote="origin"
  if [[ -n $1 ]]; then
    remote=$1
  fi

  local res=in-a-git-repo
  if [[ res -eq 0 ]]; then
    git remote get-url "${remote}" | sed -E 's@^(git|ssh|https)[\@:+](//)?((.+[\@])?(git-)?([^:/.]+)).+$@\6@'
  else
    echo ""
  fi
}

function git-stage-removed-files() {
  git ls-files -d -z | xargs -0 git update-index --remove
}

function git-add-alias() {
  if [[ -n $1 ]]; then
    git add "$@"
  else
    git add .
  fi
}

function git-switch-alias() {
  if [[ -n $1 ]]; then
    git switch "$@"
  else
    git switch main
  fi
}

alias git-checkout-alias="git-switch-alias"
