#!/usr/bin/env bash
# shellcheck disable=2034
#
# Skipping 2034 because this script specifically is loading variables into the environment only,
# we do NOT want to export them but instead use them "within" the shell instance only.

### START Sourced Check
sourced=0
if [[ -n "${ZSH_VERSION:-}" ]]; then
  [[ $ZSH_EVAL_CONTEXT =~ :file$ ]] && sourced=1 || sourced=0
elif [[ -n "$BASH_VERSION" ]]; then
  (return 0 2> /dev/null) && sourced=1 || sourced=0
else # All other shells: examine $0 for known shell binary filenames.
  # Detects `sh` and `dash`; add additional shell filenames as needed.
  case ${0##*/} in sh | -sh | dash | -dash) sourced=1 ;; *) sourced=0 ;; esac
fi

if [[ ${sourced} -eq 0 ]]; then
  echo "This script should only be sourced, never called directly." >&2
  exit 1
fi
unset sourced
### END Sourced Check

#### START: Logging and Diagnostics

function log() {
  if [[ -n "${ZSH_VERSION:-}" ]]; then
    # We are in zsh
    if [[ ${ZSHRC_LOGS:-0} -eq 1 ]]; then
      local log_file stamp
      log_file="${USER_DIRS_PROFILE:-${HOME}/profile}/zshrc.log"
      stamp="$(/usr/bin/date '+%F %I:%M:%S.%N %p')"

      echo -e "${stamp}: $1" >> "${log_file}"
    fi
  else
    # Assume bash (or posix sh)
    if [[ ${BASHRC_LOGS:-0} -eq 1 ]]; then
      local log_file stamp
      log_file="${USER_DIRS_PROFILE:-${HOME}/profile}/bashrc.log"
      stamp="$(/usr/bin/date '+%F %I:%M:%S.%N %p')"

      echo -e "${stamp}: $1" >> "${log_file}"
    fi
  fi
}

log "In base-functions"

#### FINISH: Logging and Diagnostics

log "Checking if we need to source base profile"
if [[ ${BASE_PROFILE_LOADED:-0} -ne 1 ]]; then
  g_script_dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
  # Source base-profile.bash
  if [[ -f "${g_script_dir}/base-profile.bash" ]]; then
    log "Sourcing: ${g_script_dir}/base-profile.bash"
    builtin source "${g_script_dir}/base-profile.bash"
  fi
  unset g_script_dir
else
  log "Base profile already loaded."
fi

#### START: Basic Utilities

# Function to make checking executable existence easier
function command_exists() {
  command -v "$1" &> /dev/null && return 0 || return 1
}

# function to make sourcing an optional item easier
function source_if {
  if [[ -f "$1" ]]; then
    # shellcheck source=/dev/null
    log "Sourcing: '$1'"
    builtin source "$1"
  else
    log "File '$1' does not exist, skipping sourcing it."
  fi
}

function source_or_error {
  if [[ -f "$1" ]]; then
    # shellcheck source=/dev/null
    log "Sourcing: '$1'"
    builtin source "$1"
  else
    throw_error_msg "File '$1' does not exist, unable to source."
  fi
}

#### END: Basic Utilities

#### START: Path/Location System Utility

function user_dirs {
  local query
  query=$(echo "${1}" | tr '[:lower:]' '[:upper:]')
  case "${query}" in
    # XDG Base Paths First

    CONFIG | CONFIGHOME)
      echo "${XDG_CONFIG_HOME}"
      ;;

    CACHE | CACHEHOME)
      echo "${XDG_CACHE_HOME}"
      ;;

    DATA | DATAHOME)
      echo "${XDG_DATA_HOME}"
      ;;

    STATE | STATEHOME)
      echo "${XDG_STATE_HOME}"
      ;;

    RUNTIME | RUNTIMEDIR)
      echo "${XDG_RUNTIME_DIR}"
      ;;

    CONFIGDIRS)
      echo "${XDG_CONFIG_DIRS}"
      ;;

    DATADIRS)
      echo "${XDG_DATA_DIRS}"
      ;;

    DESKTOP)
      echo "${XDG_DESKTOP_DIR}"
      ;;

    DOWNLOAD | DOWNLOADS)
      echo "${XDG_DOWNLOAD_DIR}"
      ;;

    TEMPLATES)
      echo "${XDG_TEMPLATES_DIR}"
      ;;

    PUBLIC | PUBLICSHARE)
      echo "${XDG_PUBLICSHARE_DIR}"
      ;;

    DOCUMENTS)
      echo "${XDG_DOCUMENTS_DIR}"
      ;;

    MUSIC)
      echo "${XDG_MUSIC_DIR}"
      ;;

    PICTURES)
      echo "${XDG_PICTURES_DIR}"
      ;;

    VIDEOS)
      echo "${XDG_VIDEOS_DIR}"
      ;;

    HOME)
      echo "${HOME}"
      ;;

    PROFILE | PROFILEPATH)
      echo "${USER_DIRS_PROFILE}"
      ;;

    DOTFILES)
      echo "${USER_DIRS_DOTFILES}"
      ;;

    DOTFILESPRIVATE)
      echo "${USER_DIRS_DOTFILESPRIVATE}"
      ;;

    BASHSCRIPTS)
      echo "${SHELL_BASH_SCRIPTS}"
      ;;

    ZSHSCRIPTS)
      echo "${SHELL_ZSH_SCRIPTS}"
      ;;

    ZDOTDIR)
      echo "${ZDOTDIR}"
      ;;

    CLOUD)
      echo "${USER_DIRS_CLOUD}"
      ;;

    SOURCE)
      echo "${USER_DIRS_SOURCE}"
      ;;

    INSTALLS)
      echo "${USER_DIRS_INSTALLS}"
      ;;

    VMS | VIRTUALMACHINES)
      echo "${USER_DIRS_VMS}"
      ;;

    LOCALBIN | EXECS | EXECUTABLES | EXES)
      echo "${USER_DIRS_LOCALBIN}"
      ;;

    DOTFILESBIN)
      echo "${USER_DIRS_DOTFILESBIN}"
      ;;

    HOMEBIN | USERSBIN)
      echo "${USER_DIRS_HOMEBIN}"
      ;;

    CLOUDBIN)
      echo "${USER_DIRS_CLOUDBIN}"
      ;;

    CLOUDTEMPLATES)
      echo "${USER_DIRS_CLOUDTEMPLATES}"
      ;;

    MOUNTS)
      echo "${USER_DIRS_MOUNTS}"
      ;;

    PROCESSING)
      echo "${USER_DIRS_PROCESSING}"
      ;;

    WORK)
      echo "${USER_DIRS_WORK}"
      ;;

    CLOUDWORK)
      echo "${USER_DIRS_CLOUDWORK}"
      ;;

    WINHOME | WIN_HOME)
      echo "${WIN_HOME}"
      ;;

    "")
      echo "${HOME}"
      ;;

    *)
      echo ""
      ;;

  esac
}

# Bash functions cannot use dashes in their names, use an alias instead to accomplish the same thing
alias user-dirs="user_dirs"
alias user-dir="user_dirs"
alias user_dir="user_dirs"
alias users-dirs="user_dirs"
alias users-dir="user_dirs"
alias users_dir="user_dirs"
alias users_dirs="user_dirs"

#### FINISH: Path/Location System Utility

#### START: OS and Virtualization Detection Functions - if we are virtual, what type

function is_mac() {
  if [[ ${OS_PRIMARY:-linux} == "macos" ]]; then
    return 0
  else
    return 1
  fi
}

function is_linux() {
  if [[ ${OS_PRIMARY:-linux} == "linux" ]]; then
    return 0
  else
    return 1
  fi
}

function is_wsl() {
  # Are we running on Windows in WSL
  local kernel
  kernel=$(uname -r | tr '[:upper:]' '[:lower:]')
  if [[ "${kernel}" == *"microsoft"* ]]; then
    return 0
  else
    return 1
  fi
}

function is_windows() {
  if is_wsl; then
    return 0
  else
    return 1
  fi
}

function is_vm() {
  if [[ $(systemd-detect-virt --vm || true) == "none" ]]; then
    return 1
  else
    return 0
  fi
}

function is_container() {
  if [[ $(systemd-detect-virt --container || true) == "none" ]]; then
    return 1
  else
    return 0
  fi
}

function is_virtual() {
  if [[ "$(systemd-detect-virt || true)" == "none" ]]; then
    return 1
  else
    return 0
  fi
}

function is_vagrant() {
  if is_vm && [[ "$(grep -i '^vagrant' < /etc/passwd || true)" == "" ]]; then
    return 1
  else
    return 0
  fi
}

#### END: OS and Virtualization Detection Functions

#### START: Array Utilities

# Used to call a function or command and rather than fail due to 'set -e' in the
# current shell, grab its exit code.  This is useful\necessary when you want to
# gracefully handle the result of a command that would otherwise stop execution
# of the script due to 'set -e' being turned on.
#
# Usage: Call this function just prior to a bash function or command you wish to
# capture the exit code for.  Inputs for the second function can be passed as
# usual and they will flow through to the execution of the command.
#
# get_exit_code some_function input1 input2
#
# Afterward you can then check the ${EXIT_CODE} variable and handle it however
# you wish.
function get_exit_code() {
  EXIT_CODE=0
  # We first disable errexit in the current shell
  set +e
  (
    # Then we set it again inside a subshell
    set -e
    # ...and run the function
    "$@"
  )
  # shellcheck disable=2034
  EXIT_CODE=$?
  # And finally turn errexit back on in the current shell
  set -e
}

# Check if a string exists in an array of elements\strings
#
# Say you have an array like:  DISTROS=('debian' 'ubuntu' 'arch')
# If you wanted to verify whether the string 'debian' exists in that array, you
# could use the following:
#
# get_exit_code contains_element "debian" "${DISTROS[@]}"
# if [[ ${EXIT_CODE} -eq 0 ]]
# then
#   <string does exist in array, code goes here>
# fi
#
function contains_element() {
  for e in "${@:2}"; do
    [[ ${e} == "$1" ]] && break
  done
}

#### END: Array Utilities

#### START: APT Package Utilities

# The following two functions allow a script to check if a package exists in
# the package archives.  Note this does not check INSTALLED packages but the
# list of all available packages.  The first version, 'apt_package_exists'
# checks the current machine, while the other uses arch-chroot to check.
#
# This should be used like so:
#
# if apt_package_exists "my-package"; then
# then
#   <package exists, code goes here>
# fi
#
function apt_package_exists() {
  local apt
  apt=$(apt-cache -q=2 show "$1" 2>&1 | head -n 1 || true)
  if [[ "${apt}" == Package* ]]; then
    return 0
  else
    return 1
  fi
}

# Works just like apt_package_exists but does a chroot first.  This is
# mostly usable in installation scenarios.  By default it chroot's to /mnt
# but you can pass a second argument to override that.  The first argument is
# the package to check for.
#
function arch_chroot_apt_package_exists() {
  local apt
  apt=$(arch-chroot /mnt apt-cache -q=2 show "$1" 2>&1 | head -n 1 || true)
  if [[ "${apt}" == Package* ]]; then
    return 0
  else
    return 1
  fi
}

# Whether a package is actually installed
function apt_package_installed() {
  local pkg_count
  pkg_count=$(dpkg --get-selections | grep -c "${1}")
  if [[ ${pkg_count} -eq 0 ]]; then
    return 1
  else
    return 0
  fi
}

# chroot version of the above function
function arch_chroot_apt_package_installed() {
  local pkg_count
  pkg_count=$(arch-chroot "${2:-/mnt}" dpkg --get-selections | grep -c "${1}")
  if [[ ${pkg_count} -eq 0 ]]; then
    return 1
  else
    return 0
  fi
}

#### END: APT Package Utilities

#### START: Path Utilities

# Function to easily add a path (this version adds to the end)
# http://superuser.com/a/39995
function path_append {
  if [[ -d $1 ]] && [[ ":${PATH}:" != *":$1:"* ]]; then
    PATH="${PATH:+"${PATH}:"}$1"
  fi
}

function manpath_append {
  if [[ -d $1 ]] && [[ ":${MANPATH}:" != *":$1:"* ]]; then
    MANPATH="${MANPATH:+"${MANPATH}:"}$1"
  fi
}

# Function to easily add a path (this version adds to the beginning)
# http://superuser.com/a/39995
function path_prepend {
  if [[ -d $1 ]] && [[ ":${PATH}:" != *":$1:"* ]]; then
    PATH="$1:${PATH}"
  fi
}

function manpath_prepend {
  if [[ -d $1 ]] && [[ ":${MANPATH}:" != *":$1:"* ]]; then
    MANPATH="$1:${MANPATH}"
  fi
}

function path_remove {
  local temp=":$PATH:"
  temp="${temp//:$1:/:}"
  temp="${temp#:}"
  temp="${temp%:}"
  PATH="${temp}"
}

function manpath_remove {
  local temp=":$MANPATH:"
  temp="${temp//:$1:/:}"
  temp="${temp#:}"
  temp="${temp%:}"
  MANPATH="${temp}"
}

#### END: Path Utilities

#### START: Check Root Functions

# Two methods to check whether we are running as root or not.  The first simply
# returns a value indicating whether we are running as root or not, while the
# second will print out an error and exit.
function check_root() {
  local user_id
  user_id=$(id -u)
  if [[ ${user_id} -ne 0 ]]; then
    return 0
  fi
  return 1
}

function check_root_with_error() {
  local user_id
  user_id=$(id -u)

  if [[ ${user_id} -ne 0 ]]; then
    local error_message="${1:-""}"
    if [[ "${error_message}" == "" ]]; then
      error_message="ERROR!  You must execute this script as the 'root' user."
    fi
    local error_code="${2:-"1"}"

    throw_error_msg "${error_message}" "${error_code}"
  fi
}

#### END: Check Root Functions

#### START: OS and Global Notifications

function os_notification {
  if command_exists notify-send; then
    local title=""
    local message=""
    local notify_options=("-a" "bash")
    local notify_params=()

    if [[ -n "${2:-}" ]]; then
      title="$1"
      message="$2"
      shift 2
    else
      message="$1"
      shift 1
    fi

    if [[ -n "${3:-}" ]]; then
      local priority
      priority=$(echo "${3}" | tr "[:upper:]" "[:lower:]")
      case "${priority}" in
        "l" | "low" | "1")
          notify_options+=("-u" "low")
          ;;
        "m" | "med" | "medium" | "2")
          notify_options+=("-u" "normal")
          ;;
        "c" | "crit" | "critical" | "h" | "high" | "3")
          notify_options+=("-u" "critical")
          ;;
        "*")
          log "Unknown notification priority: ${priority}"
          ;;
      esac
      shift 1
    else
      notify_options+=("-u" "normal")
    fi

    if [[ -n "${title}" ]]; then
      notify_params+=("${title}")
    fi
    notify_params+=("${message}")

    notify-send "${notify_options[@]}" "$@" "${notify_params[@]}"
  else
    log "Notify-send is not installed, skipping notification"
  fi
}

function speech_notification {
  if command_exists festival; then
    local message="${1}"

    festival -b '(voice_cmu_us_slt_arctic_hts)' "(SayText \"${message}\")"
  else
    log "Festival is not installed, skipping speech announcement."
  fi
}

function remote_notification {
  to_be_developed
}

function os_notify {
  os_notification "$@"
}

function os_notify_and_speak {
  os_notification "$@"
  speech_notification "$@"
}

function user_notify {
  os_notification "$@"
  remote_notification "$@"
}

function all_notifications {
  os_notification "$@"
  speech_notification "$@"
  remote_notification "$@"
}

function full_notify {
  all_notifications "$@"
}

#### END: OS and Global Notifications

#### START: Terminal Text Manipulation And Color Variables

alias term_size='echo "Rows=$(tput lines) Cols=$(tput cols)"'

## Text effects

text_reset="$(tput sgr0)"
text_clear="${text_reset}"

text_bold="$(tput bold)"
text_dim="$(tput dim)"
text_bold_off="\033[22m"
text_dim_off="\033[22m"
text_normal="\033[22m"

text_underline="$(tput smul)"
text_underline_off="$(tput rmul)"

text_underline_double="\033[21m"
text_underline_dotted="\033[4:4m"
text_underline_dashed="\033[4:5m"
text_undercurl="\033[4:3m"

text_overline="\033[53m"
text_overline_off="\033[55m"

text_strikethrough="\033[9m"
text_strike="\033[9m"
text_strikethrough_off="\033[29m"
text_strike_off="\033[29m"

text_standout="$(tput bold)$(tput smso)"
text_standout_off="$(tput rmso)\033[22m"

text_italic="$(tput sitm)"
text_italic_off="$(tput ritm)"

text_reverse="$(tput rev)"
text_reverse_off="\033[27m"

text_secure="$(tput invis)"
text_conceal="$(tput invis)"
text_secure_off="\033[28m"
text_conceal_off="\033[28m"

text_blink="$(tput blink)"
text_blink_off="\033[25m"
text_blink_rapid="\033[6m"

# text_subscript="$(tput ssubm)"       # Not many terminals support this
# text_subscript_off="$(tput rsubm)"   # Not many terminals support this
# text_superscript="$(tput ssupm)"     # Not many terminals support this
# text_superscript_off="$(tput rsupm)" # Not many terminals support this

## Text Colors

text_default_color="\033[39m"
text_reset_color="\033[39m"

text_black="$(tput setaf 0)"
text_red="$(tput setaf 1)"
text_green="$(tput setaf 2)"
text_yellow="$(tput setaf 3)"
text_blue="$(tput setaf 4)"
text_magenta="$(tput setaf 5)"
text_cyan="$(tput setaf 6)"
text_white="$(tput setaf 7)"

text_bright_black="$(tput setaf 8)"
text_bright_red="$(tput setaf 9)"
text_bright_green="$(tput setaf 10)"
text_bright_yellow="$(tput setaf 11)"
text_bright_blue="$(tput setaf 12)"
text_bright_magenta="$(tput setaf 13)"
text_bright_cyan="$(tput setaf 14)"
text_bright_white="$(tput setaf 15)"

## Alternate color names for some of the colors

text_pink="${text_magenta}"          # regular magenta
text_purple="${text_bright_magenta}" # bright magenta
text_orange="${text_bright_yellow}"  # bright yellow
text_gray="${text_bright_black}"
text_grey="${text_bright_black}"
text_mid_gray="\033[38;2;169;169;169;02m"
text_mid_grey="${text_mid_gray}"

## Background colors

text_bg_default_color="\033[49m"
text_bg_reset_color="\033[49m"

text_bg_black="$(tput setab 0)"
text_bg_red="$(tput setab 1)"
text_bg_green="$(tput setab 2)"
text_bg_yellow="$(tput setab 3)"
text_bg_blue="$(tput setab 4)"
text_bg_magenta="$(tput setab 5)"
text_bg_cyan="$(tput setab 6)"
text_bg_white="$(tput setab 7)"

text_bg_bright_black="$(tput setab 8)"
text_bg_bright_red="$(tput setab 9)"
text_bg_bright_green="$(tput setab 10)"
text_bg_bright_yellow="$(tput setab 11)"
text_bg_bright_blue="$(tput setab 12)"
text_bg_bright_magenta="$(tput setab 13)"
text_bg_bright_cyan="$(tput setab 14)"
text_bg_bright_white="$(tput setab 15)"

# Alternate color names for some of the background colors

text_bg_pink="${text_bg_magenta}"          # regular magenta
text_bg_purple="${text_bg_bright_magenta}" # bright magenta
text_bg_orange="${text_bg_bright_yellow}"  # bright yellow
text_bg_gray="${text_bg_bright_black}"
text_bg_grey="${text_bg_bright_black}"
text_bg_mid_gray="\033[48;2;169;169;169;02m"
text_bg_mid_grey="${text_bg_mid_gray}"

## Line colors

text_line_black="\033[58;5;00m"
text_line_red="\033[58;5;01m"
text_line_green="\033[58;5;02m"
text_line_yellow="\033[58;5;03m"
text_line_blue="\033[58;5;04m"
text_line_magenta="\033[58;5;05m"
text_line_cyan="\033[58;5;06m"
text_line_white="\033[58;5;07m"

text_line_bright_black="\033[58;5;08m"
text_line_bright_red="\033[58;5;09m"
text_line_bright_green="\033[58;5;10m"
text_line_bright_yellow="\033[58;5;11m"
text_line_bright_blue="\033[58;5;12m"
text_line_bright_magenta="\033[58;5;13m"
text_line_bright_cyan="\033[58;5;14m"
text_line_bright_white="\033[58;5;15m"

text_line_reset="\033[59m"

#### END: Terminal Text Manipulation And Color Variables

#### START: Terminal Print Functions

function _print_folded() {
  local cols
  cols=$(tput cols)
  if ((cols <= 0)); then
    cols="${COLUMNS:-100}"
  fi

  log "Printing: $1"
  echo -e "$1" | fold -s --width "${cols}"
}

## Rules & Lines

function print_separator() {
  print_line "${@:--}"
}

function print_hr() {
  print_line "${@:--}"
}

function print_line() {
  local cols
  cols=$(tput cols)
  if ((cols <= 0)); then
    cols="${COLUMNS:-100}"
  fi

  local word="$1"
  if [[ -n "${word}" ]]; then
    local line=''
    while ((${#line} < cols)); do
      line="${line}${word}"
    done

    if [[ "${2:-}" == "heading" ]]; then
      echo -e "${text_purple}${line:0:$cols}${text_reset}"
    else
      echo -e "${line:0:$cols}"
    fi
  fi
}

function print_blank_line() {
  echo -e ""
}

function pause_output() {
  log "Pausing output"
  print_line
  read -re -sn 1 -p "Press enter to continue..."
}

## Basic print methods

function print_normal() {
  _print_folded "${text_reset}$1${text_reset}"
}

function print_normal_bold() {
  _print_folded "${text_bold}$1${text_reset}"
}

function print_bold() {
  print_normal_bold "$@"
}

## Color based print methods

function print_black() {
  _print_folded "${text_black}$1${text_reset}"
}

function print_black_bold() {
  _print_folded "${text_black}${text_bold}$1${text_reset}"
}

function print_red() {
  _print_folded "${text_red}$1${text_reset}"
}

function print_red_bold() {
  _print_folded "${text_red}${text_bold}$1${text_reset}"
}

function print_green() {
  _print_folded "${text_green}$1${text_reset}"
}

function print_green_bold() {
  _print_folded "${text_green}${text_bold}$1${text_reset}"
}

function print_yellow() {
  _print_folded "${text_yellow}$1${text_reset}"
}

function print_yellow_bold() {
  _print_folded "${text_yellow}${text_bold}$1${text_reset}"
}

function print_blue() {
  _print_folded "${text_blue}$1${text_reset}"
}

function print_blue_bold() {
  _print_folded "${text_blue}${text_bold}$1${text_reset}"
}

function print_magenta {
  _print_folded "${text_magenta}$1${text_reset}"
}

function print_magenta_bold {
  _print_folded "${text_magenta}${text_bold}$1${text_reset}"
}

function print_cyan {
  _print_folded "${text_cyan}$1${text_reset}"
}

function print_cyan_bold {
  _print_folded "${text_cyan}${text_bold}$1${text_reset}"
}

function print_white() {
  _print_folded "${text_white}$1${text_reset}"
}

function print_white_bold() {
  _print_folded "${text_white}${text_bold}$1${text_reset}"
}

function print_bright_black() {
  _print_folded "${text_bright_black}$1${text_reset}"
}

function print_bright_black_bold() {
  _print_folded "${text_bright_black}${text_bold}$1${text_reset}"
}

function print_bright_red() {
  _print_folded "${text_bright_red}$1${text_reset}"
}

function print_bright_red_bold() {
  _print_folded "${text_bright_red}${text_bold}$1${text_reset}"
}

function print_bright_green() {
  _print_folded "${text_bright_green}$1${text_reset}"
}

function print_bright_green_bold() {
  _print_folded "${text_bright_green}${text_bold}$1${text_reset}"
}

function print_bright_yellow() {
  _print_folded "${text_bright_yellow}$1${text_reset}"
}

function print_bright_yellow_bold() {
  _print_folded "${text_bright_yellow}${text_bold}$1${text_reset}"
}

function print_bright_blue() {
  _print_folded "${text_bright_blue}$1${text_reset}"
}

function print_bright_blue_bold() {
  _print_folded "${text_bright_blue}${text_bold}$1${text_reset}"
}

function print_bright_magenta {
  _print_folded "${text_bright_magenta}$1${text_reset}"
}

function print_bright_magenta_bold {
  _print_folded "${text_bright_magenta}${text_bold}$1${text_reset}"
}

function print_bright_cyan {
  _print_folded "${text_bright_cyan}$1${text_reset}"
}

function print_bright_cyan_bold {
  _print_folded "${text_bright_cyan}${text_bold}$1${text_reset}"
}

function print_bright_white() {
  _print_folded "${text_bright_white}$1${text_reset}"
}

function print_bright_white_bold() {
  _print_folded "${text_bright_white}${text_bold}$1${text_reset}"
}

## Aliased colors print methods

function print_pink() {
  _print_folded "${text_pink}$1${text_reset}"
}

function print_pink_bold() {
  _print_folded "${text_pink}${text_bold}$1${text_reset}"
}

function print_purple() {
  _print_folded "${text_purple}$1${text_reset}"
}

function print_purple_bold() {
  _print_folded "${text_purple}${text_bold}$1${text_reset}"
}

function print_orange() {
  _print_folded "${text_orange}$1${text_reset}"
}

function print_orange_bold() {
  _print_folded "${text_orange}${text_bold}$1${text_reset}"
}

function print_gray() {
  _print_folded "${text_gray}$1${text_reset}"
}

function print_gray_bold() {
  _print_folded "${text_gray}${text_bold}$1${text_reset}"
}

function print_grey() {
  _print_folded "${text_grey}$1${text_reset}"
}

function print_grey_bold() {
  _print_folded "${text_grey}${text_bold}$1${text_reset}"
}

function print_mid_gray() {
  _print_folded "${text_mid_gray}$1${text_reset}"
}

function print_mid_gray_bold() {
  _print_folded "${text_mid_gray}${text_bold}$1${text_reset}"
}

function print_mid_grey() {
  _print_folded "${text_mid_grey}$1${text_reset}"
}

function print_mid_grey_bold() {
  _print_folded "${text_mid_grey}${text_bold}$1${text_reset}"
}

## Context based print methods

function print_out() {
  log "Printing output: '$*'"
  print_normal "$@"
}

function print_output() {
  print_out "$@"
}

function print_diag() {
  log "Printing diag: '$*'"
  print_grey "$@"
}

function print_diagnostics() {
  print_diag "$@"
}

function print_info() {
  log "Printing info: '$*'"
  print_cyan "$@"
}

function print_important() {
  log "Printing important: '$*'"
  print_orange "$@"
}

function print_status() {
  log "Printing status: '$*'"
  print_blue "$@"
}

function print_success() {
  log "Printing success: '$*'"
  print_green_bold "$@"
}

function print_warning() {
  log "Printing warning: '$*'"
  print_yellow_bold "$@"
}

function print_heading {
  log "Printing heading: '$*'"
  print_purple "$@"
}

function print_heading_separator() {
  print_line "${@:--}" "heading"
}

function print_heading_sep() {
  print_line "${@:--}" "heading"
}

function print_error() {
  log "Printing error: '$*'"
  >&2 print_red_bold "$@"
}

function throw_error_msg() {
  log "Throwing error: '$*'"
  print_error "$1"
  # pause_output
  if [[ ${2:-} != "" ]]; then
    exit "$2"
  else
    exit 1
  fi
}

function to_be_developed() {
  print_warning "To Be Developed: ${FUNCNAME[1]}"
}

#### END: Terminal Print Functions

log "Leaving base-functions"
