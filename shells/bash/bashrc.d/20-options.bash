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

# Set bash to vi line edit mode
set -o vi

# Don't use ^D to exit
set -o ignoreeof

# Don't wait for job termination notification
set -o notify

# Don't allow redirection to overwrite existing files
set -o noclobber

### Globbing ###
# Turn on extended globbing
shopt -s extglob
# Resolve filenames that start with . for globbing
shopt -s dotglob
# Use case-insensitive filename globbing
shopt -s nocaseglob
# Turn on globstar **
shopt -s globstar

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# Treat arguments to the cd-command as a variable name containing a directory to cd into.
shopt -s cdable_vars

# Check the window size after each command and update LINES/COLUMNS
shopt -s checkwinsize

# Turn off shell mail handling
shopt -u mailwarn
