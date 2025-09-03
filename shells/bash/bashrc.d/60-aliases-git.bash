#!/usr/bin/env bash
# shellcheck disable=SC2139

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

alias g="git"
alias get="git"

alias gs="git status"
alias gss="git status -sb"

alias gpu="git push"
alias gpush="git push"

alias gp="git pull --all --ff-only"
alias gpl="git pull --all --ff-only"
alias gpull="git pull --all --ff-only"

alias gf="git fetch --all --tags"
alias ga="git-add-alias"
alias gc="git commit"
alias gco="git checkout"
alias gcl="git clone"
alias gd="git diff"
alias gds="git diff --cached"
alias gdc="git diff --cached"
alias gdt="git difftool -y"
alias gdts="git difftool -y --cached"
alias gdtc="git difftool -y --cached"
alias gmt="git mergetool -y"
alias gsw="git-switch-alias"
alias gr="git restore"
alias grs="git restore --staged"
alias gu="git restore --staged" # git unstage

# Since I use main and develop branches so much, add specific aliases to switch
# to those branches
alias gsm="git switch main"
alias gsd="git switch develop"
# I also also merge develop into main quite a lot
alias gmd="git merge develop --ff-only"
alias gmm="git merge main --ff-only"

alias gexp="git archive --format zip --output"

alias glog="git log --graph --pretty=oneline --abbrev-commit"
