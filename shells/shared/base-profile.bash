#!/usr/bin/env bash

# This script sets up the locations of critical paths and environment variables. It should NOT be
# sourced but executed. Ideally it should be called early on in the setup of a shell. The goal of
# this script is to have this file (along with base-functions.bash) be where path locations are
# customized. Ideally, only those two files should be where paths are set.  All other scripts should
# be able to simply and safely refer to the environment variables exported here or to use the
# user-dirs function provided within base-functions.bash.

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

function log_baseprofile() {
  if [[ ${BASHRC_LOGS:-0} -eq 1 ]]; then
    local bashrc_log_file stamp
    bashrc_log_file="${USER_DIRS_PROFILE:-${HOME}/profile}/bashrc.log"
    stamp="$(/usr/bin/date '+%F %I:%M:%S.%N %p')"

    echo -e "${stamp}: $1" >> "${bashrc_log_file}"
  fi
}

function export_profile_location {
  log_baseprofile "Exporting profile location"
  # The profile path is used by many other locations so we need to export it first
  #
  # For Mac or Linux, the profile directory should usually be in the users $HOME directory. On
  # those systems, only the USER_DIRS_PROFILE variable below needs to be exported.
  #
  # On Windows for Windows WSL I use the WSLENV environment variable to pass in some path values
  # along with a custom value WIN_USER. WIN_USER should be set as an environment variable to the
  # %USERNAME% value in Windows. The WIN_USER variable is used in situations where the Unix (WSL)
  # username and the Windows usernames might differ (which will likely be common).
  #
  # Along witn WIN_USER the environment variable USER_DIRS_PROFILE should also be configured.
  # Typically, this location is C:\profile for single disk machines or D:\profile for multi-disk
  # machines.
  #
  # All three environment variables (WIN_USER, USER_DIRS_PROFILE, and WSLENV) on Winblows should
  # be initialized with a setup script when first configuring the machine. The other parts of
  # WSLENV are USERPROFILE and SystemRoot, which are standard paths available in Windows by default.
  # The WSLENV variable should be set to: USERPROFILE/up:USER_DIRS_PROFILE/up:SystemRoot/up:WIN_USER
  #

  export USER_DIRS_PROFILE="${USER_DIRS_PROFILE:-${HOME}/profile}"
  # Create it if needed
  [[ -d "${USER_DIRS_PROFILE}" ]] || mkdir -p "${USER_DIRS_PROFILE}"
}

function export_dotfiles_locations {
  log_baseprofile "Exporting dotfiles locations"
  # The location of the dotfiles repo locations are also referred to by other locations.

  # All "home" locations should be set in only this one location, after this
  # script is loaded (either in a script or in the entire environment), all
  # locations should be set and the environment variables or user_dirs can be
  # used to resolve their locations.

  export USER_DIRS_DOTFILES="${USER_DIRS_DOTFILES:-${HOME}/.dotfiles-rc}"
  export USER_DIRS_DOTFILESPRIVATE="${USER_DIRS_DOTFILESPRIVATE:-${HOME}/.dotfiles-private}"
  # Create it if needed
  [[ -d "${USER_DIRS_DOTFILES}" ]] || mkdir -p "${USER_DIRS_DOTFILES}"
  [[ -d "${USER_DIRS_DOTFILESPRIVATE}" ]] || mkdir -p "${USER_DIRS_DOTFILESPRIVATE}"
}

function export_xdg_base_locations {
  log_baseprofile "Exporting XDG base locations"
  # Documentation: https://specifications.freedesktop.org/basedir-spec/latest/
  #

  local user_id
  user_id=$(id -u)

  export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
  export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
  export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
  export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"
  export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/${user_id}}"

  # Create them if needed
  [[ -d "${XDG_CONFIG_HOME}" ]] || mkdir -p "${XDG_CONFIG_HOME}"
  [[ -d "${XDG_CACHE_HOME}" ]] || mkdir -p "${XDG_CACHE_HOME}"
  [[ -d "${XDG_DATA_HOME}" ]] || mkdir -p "${XDG_DATA_HOME}"
  [[ -d "${XDG_STATE_HOME}" ]] || mkdir -p "${XDG_STATE_HOME}"
  [[ -d "${XDG_RUNTIME_DIR}" ]] || mkdir -p "${XDG_RUNTIME_DIR}"

  # These two are "special".
  # TODO: Fill in with other directories as needed (flatpak, etc.)
  export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-"/etc/xdg"}"
  export XDG_DATA_DIRS="${XDG_DATA_DIRS:-"/usr/local/share/:/usr/share/"}"
}

function export_xdg_desktop_locations {
  log_baseprofile "Exporting XDG desktop locations"
  # Documentation: https://wiki.archlinux.org/title/XDG_user_directories
  #

  if command -v "xdg-user-dirs-update" &> /dev/null; then
    # Use the tool to set the values
    xdg-user-dirs-update --set DESKTOP "${HOME}/Desktop"
    xdg-user-dirs-update --set DOWNLOAD "${USER_DIRS_PROFILE}/downloads"
    xdg-user-dirs-update --set TEMPLATES "${USER_DIRS_DOTFILES}/templates"
    xdg-user-dirs-update --set PUBLICSHARE "${HOME}/Public"
    xdg-user-dirs-update --set DOCUMENTS "${USER_DIRS_PROFILE}/documents"
    xdg-user-dirs-update --set MUSIC "${USER_DIRS_PROFILE}/music"
    xdg-user-dirs-update --set PICTURES "${USER_DIRS_PROFILE}/pictures"
    xdg-user-dirs-update --set VIDEOS "${USER_DIRS_PROFILE}/videos"
  fi

  # What I'm doing here is reading the user-dirs.dirs file and exporting each entry
  # as an environment variable (such as XDG_DOWNLOAD_DIR).
  #
  # I have to manually read the lines from user-dirs.dirs in order to prepend
  # each line with an explicit call to "export"
  if [[ -f "${XDG_CONFIG_HOME}/user-dirs.dirs" ]]; then
    while read -r line; do
      if [[ ! ${line} =~ ^"#" && ! "${line}" == "" ]]; then
        eval "export ${line}"
      fi
    done < "${XDG_CONFIG_HOME}/user-dirs.dirs"
  fi

  # Just in case the above file loop didn't set the locations
  : "${XDG_DESKTOP_DIR:=${HOME}/Desktop}"
  : "${XDG_DOWNLOAD_DIR:=${USER_DIRS_PROFILE}/downloads}"
  : "${XDG_TEMPLATES_DIR:=${USER_DIRS_DOTFILES}/templates}"
  : "${XDG_PUBLICSHARE_DIR:=${HOME}/Public}"
  : "${XDG_DOCUMENTS_DIR:=${USER_DIRS_PROFILE}/documents}"
  : "${XDG_MUSIC_DIR:=${USER_DIRS_PROFILE}/music}"
  : "${XDG_PICTURES_DIR:=${USER_DIRS_PROFILE}/pictures}"
  : "${XDG_VIDEOS_DIR:=${USER_DIRS_PROFILE}/videos}"

  [[ -d "${XDG_DESKTOP_DIR}" ]] || mkdir -p "${XDG_DESKTOP_DIR}"
  [[ -d "${XDG_DOWNLOAD_DIR}" ]] || mkdir -p "${XDG_DOWNLOAD_DIR}"
  [[ -d "${XDG_TEMPLATES_DIR}" ]] || mkdir -p "${XDG_TEMPLATES_DIR}"
  [[ -d "${XDG_PUBLICSHARE_DIR}" ]] || mkdir -p "${XDG_PUBLICHSHARE_DIR}"
  [[ -d "${XDG_DOCUMENTS_DIR}" ]] || mkdir -p "${XDG_DOCUMENTS_DIR}"
  [[ -d "${XDG_MUSIC_DIR}" ]] || mkdir -p "${XDG_MUSIC_DIR}"
  [[ -d "${XDG_PICTURES_DIR}" ]] || mkdir -p "${XDG_PICTURES_DIR}"
  [[ -d "${XDG_VIDEOS_DIR}" ]] || mkdir -p "${XDG_VIDEOS_DIR}"
}

function export_my_extension_locations {
  log_baseprofile "Exporting custom locations"
  # I have already exported the profile and dotfiles locations, this is for other common locations
  # that I use.

  # First, shell script locations
  export SHELL_BASH_SCRIPTS="${USER_DIRS_DOTFILES}/shells/bash"
  export SHELL_ZSH_SCRIPTS="${USER_DIRS_DOTFILES}/shells/zsh"
  # export ZDOTDIR="${ZDOTDIR:-${USER_DIRS_DOTFILES}/shells/zsh}"

  # Profile directories
  export USER_DIRS_CLOUD="${USER_DIRS_PROFILE}/cloud/files"
  export USER_DIRS_SOURCE="${USER_DIRS_PROFILE}/source"
  export USER_DIRS_INSTALLS="${USER_DIRS_PROFILE}/installs"
  export USER_DIRS_VMS="${USER_DIRS_PROFILE}/vms"

  [[ -d "${USER_DIRS_CLOUD}" ]] || mkdir -p "${USER_DIRS_CLOUD}"
  [[ -d "${USER_DIRS_SOURCE}" ]] || mkdir -p "${USER_DIRS_SOURCE}"
  [[ -d "${USER_DIRS_INSTALLS}" ]] || mkdir -p "${USER_DIRS_INSTALLS}"
  [[ -d "${USER_DIRS_VMS}" ]] || mkdir -p "${USER_DIRS_VMS}"

  # Bin directories
  export USER_DIRS_LOCALBIN="${HOME}/.local/bin"
  export USER_DIRS_DOTFILESBIN="${USER_DIRS_DOTFILES}/bin"
  export USER_DIRS_HOMEBIN="${HOME}/.bin"
  export USER_DIRS_CLOUDBIN="${USER_DIRS_CLOUD}/bin"

  # Few others
  export USER_DIRS_CLOUDTEMPLATES="${USER_DIRS_CLOUD}/templates"
  export USER_DIRS_MOUNTS="${HOME}/mounts"
  export USER_DIRS_PROCESSING="${USER_DIRS_PROFILE}/processing"

  [[ -d "${USER_DIRS_MOUNTS}" ]] || mkdir -p "${USER_DIRS_MOUNTS}"
  [[ -d "${USER_DIRS_PROCESSING}" ]] || mkdir -p "${USER_DIRS_PROCESSING}"

  # For work
  export USER_DIRS_WORK="${USER_DIRS_PROFILE}/work"
  export USER_DIRS_CLOUDWORK="${USER_DIRS_CLOUD}/work"

  [[ -d "${USER_DIRS_WORK}" ]] || mkdir -p "${USER_DIRS_WORK}"
}

function export_mise_settings {
  local mise_exe="${USER_DIRS_LOCALBIN}/mise"
  if [[ -x ${mise_exe} ]]; then
    log_baseprofile "Exporting MISE setting environment variables"
    export RUSTUP_INIT_SKIP_PATH_CHECK="yes"
    export MISE_RUSTUP_HOME="${XDG_STATE_HOME}/rustup"
    export MISE_CARGO_HOME="${XDG_DATA_HOME}/cargo"

    export MISE_NODE_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/mise/default-node-packages"
    export MISE_NODE_COREPACK="true"
  fi

  export UV_TOOL_BIN_DIR="${HOME}/.local/uv/bin"
}

function export_os_details {
  log_baseprofile "Exporting os_details"
  # OS_PRIMARY indicates the broad OS "type": "macos", "linux", "bsd", or "unknown".
  # OS_SECONDARY would indicate the "distribution" of the type, so on Linux the distro name like
  # Debian or Ubuntu, or for BSD like openbsd or freebsd.
  #
  # NOTE: On Windows, this value still exports as "linux" (under Windows Subsystem For Linux) so
  # this value SHOULD NOT be used to determine if you are running on Windows.
  #
  local uname
  uname=$(uname -s | tr '[:upper:]' '[:lower:]' || true)

  if [[ ${uname} == "darwin" ]]; then
    OS_PRIMARY="macos"
    OS_SECONDARY="macos" # TODO: Update to indicate which edition of Mac? "monterey", "sequoia"?
  elif [[ ${uname} == "linux" ]]; then
    OS_PRIMARY="linux"
    OS_SECONDARY=$(grep -i '^ID=' < /etc/os-release | sed -e 's/^ID=//;s/"//g' | tr '[:upper:]' '[:lower:]' || true)
    if [[ "${OS_SECONDARY}" == "" ]]; then
      OS_SECONDARY="unknown"
    fi
  elif [[ ${uname} == "freebsd" ]]; then
    OS_PRIMARY="bsd"
    OS_SECONDARY="freebsd"
  elif [[ ${uname} == "openbsd" ]]; then
    OS_PRIMARY="bsd"
    OS_SECONDARY="openbsd"
  else
    OS_PRIMARY="unknown"
    OS_SECONDARY="unknown"
  fi

  export OS_PRIMARY
  export OS_SECONDRAY
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

function export_winhome {
  log_baseprofile "Exporting win_home"
  if is_wsl; then
    # Do nothing if not in a Windows Substem For Linux (WSL) environment
    return
  fi

  # This is only here for Windows and WSL.  For all non-Windows machines $HOME is "home", but
  # for my WSL shells I keep track of two homes.  The "Linux" home stays as "home" (cd -) but
  # I also track the "windows" home (usually C:\Users\<username>).  This I map to the alias cdh.
  # On Mac and Linux cdh is the same as just cd, but on Windows they will be two different paths
  # with two different environment variables $HOME and $WIN_HOME pointing to each, respectively.
  export WIN_HOME="${USERPROFILE:-${HOME}}"
  # Create it if needed
  [[ -d "${WIN_HOME}" ]] || mkdir -p "${WIN_HOME}"
}

function base_profile {
  log_baseprofile "In base-profile"
  export_profile_location
  export_dotfiles_locations

  export_xdg_base_locations

  export_xdg_desktop_locations

  export_my_extension_locations

  export_mise_settings

  export_os_details
  export_winhome

  export BASE_PROFILE_LOADED=1
  log_baseprofile "base-profile finished"
}

base_profile "$@"
