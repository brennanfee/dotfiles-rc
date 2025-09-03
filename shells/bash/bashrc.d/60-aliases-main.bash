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

# Turn on colors
alias ls='ls $LS_OPTIONS --classify=always'
alias lss='ls -1 --classify=never'
alias dir='ls -CA  --classify=always'
alias vdir='ls -lA --classify=always'
alias tree="tree -C"
alias as-tree="tree -C --fromfile"

alias grep="grep --color=auto"
alias pgrep="grep --color=auto"
alias egrep="grep --color=auto"

alias lsgrep="ls -A | grep -i --color=never"
alias llgrep="ls -hlA --time-style=long-iso | grep -i --color=never"

alias lsrg="ls -A | rg -S --color=never"
alias llrg="ls -hlA --time-style=long-iso | rg -S --color=never"

function psgrep() {
  # shellcheck disable=SC2009,SC2001
  ps aux | grep -i --color=never "$(echo "$@" | sed "s/^\(.\)/[\1]/g")"
}

function psrg() {
  # shellcheck disable=SC2001
  ps aux | rg -S --color=never "$(echo "$@" | sed "s/^\(.\)/[\1]/g")"
}

# Make sudo preserve home
alias sudo="sudo -H"
alias se="sudoedit"

# Alternates/extensions of ls
alias la="ls -A"
alias ll="ls -oh"
alias lla="ls -ohA"
alias lls="ls -lhA"
alias ldir='ls -ohA --color=never | grep --color=never "^d"'

alias sl="ls"

# Directory & file
alias md='mkdir -p'
alias mkdir="mkdir -p"

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# DOS like clear
alias cls="clear"

# Vim shell typos
alias :q="exit"
alias :wq="exit"
alias :x="exit"

# RipGrep should always use "smart-case"
if command_exists rg; then
  alias rg='rg -S -p'
fi

# History
alias histg='history | grep'
if command_exists rg; then
  alias hist='history | rg -S -p'
else
  alias hist='history | grep'
fi

# Utility commands
alias mkdatedir='mkdir $(date "+%Y-%m-%d")'
alias mkdatefile='touch $(date "+%Y-%m-%d").txt'

# CD typos
alias cd.='cd ..'
alias cd..='cd ..'
alias cdu='cd ..'

# wget
# shellcheck disable=SC2139
alias wget='wget --hsts-file="${XDG_DATA_HOME:-$(user_dirs DATA)}/wget-hsts"'

# Set up alias for fd
if command_exists fdfind; then
  alias fd="fdfind"
fi

if command_exists thefuck; then
  eval "$(thefuck --alias || true)"
fi

if command_exists ansible-community; then
  alias ansible="ansible-community"
fi

if command_exists colorscripts; then
  alias colortest="colorscripts tests"
fi
