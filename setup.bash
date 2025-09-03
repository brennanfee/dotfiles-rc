#!/usr/bin/env bash
# setup.bash - Script to set up a new machine with my dotfiles.

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

# Current directory
dotfiles="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=/home/brennan/.dotfiles-rc/shells/shared/base-profile.bash
source "${dotfiles}/shells/shared/base-profile.bash"
# shellcheck source=/home/brennan/.dotfiles-rc/shells/shared/base-functions.bash
source "${dotfiles}/shells/shared/base-functions.bash"

# At this point, we can rely on the environment variables that were set as part of base-profile.bash.
dotfiles=${USER_DIRS_DOTFILES}
dotfiles_private=${USER_DIRS_DOTFILESPRIVATE}

echo ""
echo -e "${text_green}Starting setup...${text_reset}"
echo ""

if ! command -v "rcup" &> /dev/null; then
  echo -e "${text_red}RCM is not installed.  Please install it and try again.${text_reset}"
  exit 1
fi

if ! command -v "curl" &> /dev/null; then
  echo -e "${text_red}Curl is not installed.  Please install it and try again.${text_reset}"
  exit 1
fi

rcup -f -K -d "${dotfiles}/rcs" -d "${dotfiles_private}/rcs" rcrc

if [[ -f "${HOME}/.rcrc" ]]; then
  echo -e "${text_yellow}Home .rcrc is in place.${text_reset}"
  echo ""
else
  echo -e "${text_white}Creating new ~/.rcrc file.${text_reset}"
  echo ""
  cp "${dotfiles}/base-rcrc" "${HOME}/.rcrc"

  if [[ ${OS_PRIMARY} == "linux" ]]; then
    echo "TAGS=\"${OS_PRIMARY} ${OS_SECONDARY} home\"" >> "${HOME}/.rcrc"
  else
    echo "TAGS=\"${OS_PRIMARY} home\"" >> "${HOME}/.rcrc"
  fi

  echo -e "${text_yellow}~/.rcrc file created.  You will need to add it with mkrc -o ~/.rcrc${text_reset}"
fi

echo -e "${text_green}Done!  Edit the ~/.rcrc as needed then run 'rcup'${text_reset}"
echo ""

unset dotfiles
unset dotfiles_private
