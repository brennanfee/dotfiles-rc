#!/usr/bin/env zsh
#
# .zprofile - Zsh file loaded on login.
#

function log_profile {
  if [[ ${ZSHRC_LOGS:-0} -eq 1 ]]; then
    local log_file stamp
    log_file="${USER_DIRS_PROFILE:-${HOME}/profile}/zshrc.log"
    stamp="$(/usr/bin/date '+%F %I:%M:%S.%N %p')"

    echo -e "${stamp}: $1" >>"${log_file}"
  fi
}

function source_profile_script {
  local base_profile_script="${ZDOTDIR}/../shared/base-profile.bash"
  if [[ -s "${base_profile_script}" && "${BASE_PRORFILE_LOADED:-0}" -ne 1 ]]; then
    log_profile "Sourcing: ${base_profile_script}"
    builtin source "${base_profile_script}"
  fi
}

function profile_activate_mise_shims {
  local mise_exe="${USER_DIRS_LOCALBIN:-${HOME}/.local/bin}/mise"
  if [[ -x ${mise_exe} ]]; then
    log_profile "Activating mise shims"
    eval "$(${mise_exe} activate zsh --shims)"
  fi
}

function zprofile {
  log_profile "In zprofile"
  log_profile "Start Profile ZDOTDIR: ${ZDOTDIR}"
  log_profile "Start Profile PATH: ${PATH}"
  log_profile "Base profile loaded: ${BASE_PROFILE_LOADED:-0}"
  if [[ -o login ]]; then log_profile 'Login shell'; else log_profile 'Non-login shell'; fi
  if [[ -o interactive ]]; then log_profile 'Interactive shell'; else log_profile 'Non-interactive shell'; fi

  source_profile_script

  profile_activate_mise_shims

  log_profile "Profile PATH: ${PATH}"
  log_profile "Leaving zprofile"
}

zprofile "$@"
unset -f log_profile
unset -f source_profile_script
unset -f profile_activate_mise_shims
unset -f zprofile

#
# Browser
#

# if [[ "$OSTYPE" == darwin* ]]; then
#   export BROWSER="${BROWSER:-open}"
# fi

#
# Editors
#

# export EDITOR="${EDITOR:-vim}"
# export VISUAL="${VISUAL:-vim}"
# export PAGER="${PAGER:-less}"

#
# Regional Settings
#

# export LANG="${LANG:-en_US.UTF-8}"

#
# Paths
#

# Ensure path arrays do not contain duplicates.
# typeset -gU path fpath cdpath mailpath

# set the list of directories that `cd` searches
# cdpath=(
#   ~/Projects
#   $cdpath
# )

# Set the list of directories that zsh searches for commands.
# path=(
#   $HOME/{,s}bin(N)
#   /usr/local/{,s}bin(N)
#   $path
# )

#
# Less
#

# Set default less options.
# export LESS="${LESS:--g -i -M -R -S -w -z-4}"

# # Set the less input preprocessor.
# if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
#   export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
# fi

#
# Misc
#

# Use `< file` to quickly view the contents of any file.
# [[ -z "$READNULLCMD" ]] || READNULLCMD=$PAGER

# Make Apple Terminal behave.
#
# export SHELL_SESSIONS_DISABLE=1
