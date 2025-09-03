#!/usr/bin/env bash

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

## Your main implementation goes here.  All of the positional arguments have been passed as an array
## to this function.
function main() {
  local msg
  # TODO: Create a method to center text
  echo -e "                                        ${text_bold}TermTest${text_reset}"
  echo ""
  echo "-- Normal, Bold, And Dim --"
  echo ""
  msg="${text_normal}Normal${text_normal}  ${text_yellow}Normal Yellow${text_normal}"
  msg+="   ${text_bold}${text_white}Bold${text_normal}"
  msg+="   ${text_bold}${text_yellow}Bold Yellow${text_normal}   ${text_dim}${text_white}Dim${text_normal}"
  msg+="   ${text_dim}${text_yellow}Dim Yellow${text_normal}"
  echo -e "${msg}"
  msg="${text_bright_white}Bright${text_normal}    ${text_bright_yellow}Bright Yellow${text_normal}"
  msg+="   ${text_bold}${text_bright_white}Bright Bold${text_normal}"
  msg+="   ${text_bold}${text_bright_yellow}Bright Bold Yellow${text_normal}"
  msg+="   ${text_dim}${text_bright_white}Bright Dim${text_normal}"
  msg+="   ${text_dim}${text_bright_yellow}Bright Dim Yellow${text_reset}"
  echo -e "${msg}"
  msg="${text_bold}${text_dim}${text_yellow}Bold-Dim Yellow${text_reset}"
  msg+="   ${text_dim}${text_bold}${text_yellow}Dim-Bold Yellow${text_reset}"
  msg+="   ${text_bold}${text_dim}${text_bright_yellow}Bold-Dim Bright Yellow${text_reset}"
  msg+="   ${text_dim}${text_bold}${text_bright_yellow}Dim-Bold Bright Yellow${text_reset}"
  echo -e "${msg}"
  echo ""
  echo "-- Text Effects --"
  echo ""
  msg="${text_italic}Italic${text_normal}   ${text_bold}${text_italic}Bold Italic${text_normal}"
  msg+="   ${text_dim}${text_italic}Dim Italic${text_normal}"
  msg+="   ${text_italic}${text_bright_white}Bright Italic${text_normal}"
  msg+="   ${text_bold}${text_italic}${text_bright_white}Bright Bold Italic${text_normal}"
  echo -e "${msg}"
  msg="${text_italic}${text_bright_yellow}Bright Yellow Italic${text_normal}"
  msg+="   ${text_bold}${text_italic}${text_bright_yellow}Bright Yellow Bold Italic${text_normal}"
  msg+="   ${text_dim}${text_italic}${text_bright_yellow}Bright Yellow Dim Italic${text_reset}"
  echo -e "${msg}"
  msg="${text_conceal}Conceal${text_conceal_off}   <-- Concealed (aka 'secure')"
  echo -e "${msg}"
  msg="${text_reverse}Reverse${text_reverse_off}   ${text_standout}Standout${text_standout_off}"
  msg+="   ${text_blink}Blink${text_blink_off}${text_reset}"
  echo -e "${msg}"
  echo ""
  echo "-- Lines --"
  echo ""
  msg="${text_overline}Overline${text_overline_off}"
  msg+="   ${text_overline}${text_line_blue}Overline Blue${text_overline_off}${text_line_reset}"
  msg+="   ${text_underline}${text_overline}${text_line_magenta}Overline And Underline "
  msg+="Magenta${text_overline_off}${text_underline_off}${text_line_reset}"
  echo -e "${msg}"
  echo ""
  msg="${text_underline}Underline${text_underline_off}"
  msg+="   ${text_underline_double}Double Underline${text_underline_off}"
  msg+="   ${text_underline_dotted}Dotted Underline${text_underline_off}"
  msg+="   ${text_underline_dashed}Dashed Underline${text_underline_off}"
  echo -e "${msg}"
  msg="${text_strikethrough}Strikethrough${text_strikethrough_off}"
  msg+="   ${text_strikethrough}${text_line_bright_red}${text_bright_green}Strikethrough Bright "
  msg+="Green Text Bright Red Line${text_reset}"
  echo -e "${msg}"
  msg="${text_undercurl}Undercurl${text_reset}"
  msg+="   ${text_undercurl}${text_line_bright_cyan}Undercurl Bright Cyan${text_reset}"
  msg+="   ${text_undercurl}${text_line_bright_red}Undercurl Bright Red${text_reset}"
  msg+="   ${text_underline_double}${text_line_bright_yellow}${text_blue}Double Underline Blue "
  msg+="Text Bright Yellow Line${text_reset}"
  echo -e "${msg}"
  echo ""
  echo "-- Other --"
  echo ""
  echo "Ligatures: == === !== >= <= =>"
  echo "Font icons:  契            勒  鈴  "
  echo "Color emojis:  😄  💜  🎵  💾  💩  ⛔"
}

## This must be the last line
main_handler "$@"
