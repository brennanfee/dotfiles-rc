#!/usr/bin/env bash
#
# This file was originally taken from iterm2 https://github.com/gnachman/iTerm2/blob/master/tests/24-bit-color.sh
#
#   This file echoes a bunch of 24-bit color codes
#   to the terminal to demonstrate its functionality.
#   The foreground escape sequence is ^[38;2;<r>;<g>;<b>m
#   The background escape sequence is ^[48;2;<r>;<g>;<b>m
#   <r> <g> <b> range from 0 to 255 inclusive.
#   The escape sequence ^[0m returns output to default
#

### START Bash strict mode
sourced=0
if [[ -n "${ZSH_VERSION:-}" ]]; then
  [[ ${ZSH_EVAL_CONTEXT:-} =~ :file$ ]] && sourced=1 || sourced=0
elif [[ -n "${BASH_VERSION:-}" ]]; then
  (return 0 2> /dev/null) && sourced=1 || sourced=0
else # All other shells: examine $0 for known shell binary filenames.
  # Detects `sh` and `dash`; add additional shell filenames as needed.
  case ${0##*/} in sh | -sh | dash | -dash) sourced=1 ;; *) sourced=0 ;; esac
fi

if [[ "${sourced}" -ne 1 ]]; then
  set -o errexit  # same as set -e
  set -o nounset  # same as set -u
  set -o errtrace # same as set -E
  set -o pipefail
  set -o posix
  #set -o xtrace # same as set -x, turn on for debugging

  shopt -s extdebug
  IFS=$(printf '\n\t')
fi
unset sourced
### END Bash strict mode

###################################################################################################
### START Script template bootstrap

function initialize() {
  g_script_name=$(basename "${BASH_SOURCE[0]}")
  g_script_dir="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

  g_short_options=""
  g_long_options=""
  g_positional_arguments=""
}

function cleanup_vars() {
  unset g_script_name
  unset g_script_dir

  unset g_short_options
  unset g_long_options
  unset g_positional_arguments

  unset g_script_author
  unset g_script_license
  unset g_script_version
  unset g_script_date

  cleanup_script_vars
}

function load_base_functions() {
  local functions_script="${USER_DIRS_DOTFILES:-${HOME}/.dotfiles-rc}/shells/shared/base-functions.bash"

  if [[ -f "${functions_script}" ]]; then
    # shellcheck source=/home/brennan/.dotfiles-rc/shells/shared/base-functions.bash
    builtin source "${functions_script}"
  fi
}

function show_version() {
  print_out "Application: ${g_script_name}"
  print_out "Author: ${g_script_author} --- License: ${g_script_license}"
  print_out "Version: ${g_script_version} --- Date: ${g_script_date}"
  print_blank_line
}

function show_help() {
  show_version
  print_help
}

function set_short_options() {
  g_short_options="$1"
}

function set_long_options() {
  g_long_options="$1"
}

function process_arguments() {
  local args
  set +o errexit # temporarily turn off error on exit
  args=$(getopt --name "${g_script_name}" --options "${g_short_options}hv" \
    --longoptions "${g_long_options},help,version" -- "$@")
  # Handle if getopt returned an error
  # shellcheck disable=SC2181
  if [[ $? -gt 0 ]]; then
    show_help
    exit 1
  fi
  set -o errexit # turn error on exit back on

  eval set -- "${args}"

  ## Handle the required options, help & version, bypass everything else
  local flags=("$@")
  local i=0
  while [[ "${i}" -lt "${#flags[@]}" ]]; do
    local flag=${flags[i]}
    if [[ "${flag}" == "-h" || "${flag}" == "--help" ]]; then
      show_help
      exit 0
    elif [[ "${flag}" == "-v" || "${flag}" == "--version" ]]; then
      show_version
      exit 0
    elif [[ "${flag}" == "--" ]]; then
      break
    fi
    i=$((i + 1))
  done

  # Split up the flags and positionals
  local flags=() positional_arguments=()
  local reached_positionals=0
  while [[ $# -gt 0 ]]; do
    if [[ "$1" == "--" ]]; then
      reached_positionals=1
      shift
    else
      if [[ "${reached_positionals}" -eq 1 ]]; then
        positional_arguments+=("$1")
        shift
      else
        flags+=("$1")
        shift
      fi
    fi
  done

  process_flags "${flags[@]}"
  g_positional_arguments=("${positional_arguments[@]}")
}

## USAGE: First parameter should be the number of expected (required) positional arguments.
## Optionally, you can pass in a second argument to customize the error message.
function validate_number_of_positional_arguments() {
  local expected_arguments=$1
  local error_msg="${2:-Invalid number of arguments, expected at least ${expected_arguments}.}"

  if [[ "${#g_positional_arguments[@]}" -lt ${expected_arguments} ]]; then
    print_error "${error_msg}"
    show_help
    exit 1
  fi
}

function main_handler() {
  initialize
  load_base_functions
  setup_script_vars
  setup_options
  process_arguments "$@"
  main "${g_positional_arguments[@]}"
  cleanup_vars
}

### END Script template bootstrap
###################################################################################################

## USAGE: If you want any global variables, set them up here
function setup_script_vars() {
  # Must be set here
  g_script_author="Brennan Fee"
  g_script_license="MIT License"
  g_script_version="0.4"
  g_script_date="2025-04-08"

  # Add others here
}

## USAGE: If you add any global variables, clean them up in this method
function cleanup_script_vars() {
  # unset abc

  true
}

## USAGE: If you need to add any command-line flags or options, do it here.
## You should call one or both of the helper methods set_short_options or
## set_long_options.  They accept a string with syntax that is the same for
## the getopt program.  See it's help for more information.
function setup_options() {
  # set_short_options "abc:"
  # set_long_options "beta,charlie:"

  true
}

## Usage: If you added command-line flags or options using setup_options,
## process them here.  The flags and their values will be passed as an array
## directly into this method so you can process them however you wish,
## including using 'shift' as you loop.
function process_flags() {
  # while [[ $# -gt 0 ]]; do
  #   case "$1" in
  #   '-a')
  #     alpha=1 # or "yes"
  #     shift
  #     ;;
  #   '-c' | '--charlie')
  #     charlie="$2"
  #     shift 2
  #     ;;
  #   '--')
  #     shift
  #     break
  #     ;;
  #   *)
  #     throw_error_msg "Unknown option: $1"
  #     ;;
  #   esac
  # done

  true
}

## USAGE: Construct your help screen text here.
function print_help() {
  to_be_developed
}

function setBackgroundColor() {
  #printf '\x1bPtmux;\x1b\x1b[48;2;%s;%s;%sm' $1 $2 $3
  printf '\x1b[48;2;%s;%s;%sm' "$1" "${2:-}" "${3:-}"
}

function resetOutput() {
  echo -en "\x1b[0m\n"
}

## Your main implementation goes here.  All of the positional arguments have been passed as an array
## to this function.
function main() {
  for i in $(seq 0 127); do
    setBackgroundColor "${i}" 0 0
    echo -en " "
  done
  resetOutput

  for i in $(seq 255 -1 128); do
    setBackgroundColor "${i}" 0 0
    echo -en " "
  done
  resetOutput

  for i in $(seq 0 127); do
    setBackgroundColor 0 "${i}" 0
    echo -n " "
  done
  resetOutput

  for i in $(seq 255 -1 128); do
    setBackgroundColor 0 "${i}" 0
    echo -n " "
  done
  resetOutput

  for i in $(seq 0 127); do
    setBackgroundColor 0 0 "${i}"
    echo -n " "
  done
  resetOutput

  for i in $(seq 255 -1 128); do
    setBackgroundColor 0 0 "${i}"
    echo -n " "
  done
  resetOutput
}

## This must be the last line
main_handler "$@"
