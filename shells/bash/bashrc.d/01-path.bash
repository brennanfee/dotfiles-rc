#!/usr/bin/env bash

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

function set_path() {
  log "Path before customizations: ${PATH}"

  local base_data_dir base_bin_dir base_homebin_dir base_dotfiles_dir base_dotfilesprivate_dir
  local base_cloud_dir mise_shims_dir
  local path_system_original the_path base

  base_data_dir="${XDG_DATA_HOME:-$(user_dirs DATA)}"
  base_bin_dir="${USER_DIRS_LOCALBIN:-$(user_dirs LOCALBIN)}"
  base_homebin_dir="${USER_DIRS_HOMEBIN:-$(user_dirs HOMEBIN)}"
  base_dotfiles_dir="${USER_DIRS_DOTFILES:-$(user_dirs DOTFILES)}"
  base_dotfilesprivate_dir="${USER_DIRS_DOTFILESPRIVATE:-$(user_dirs DOTFILESPRIVATE)}"
  base_cloud_dir="${USER_DIRS_CLOUD:-$(user_dirs CLOUD)}"

  mise_shims_dir="${base_data_dir}/mise/shims"

  path_remove "${mise_shims_dir}"
  path_system_original="${PATH}"
  # shellcheck disable=SC2123
  PATH=""

  ### NOTE: Order is important

  # Home (local override), should always be the "first" to override everything else
  path_append "${base_homebin_dir}"

  # Cloud bin should be next
  path_append "${base_cloud_dir}/bin"

  # Then dotfiles
  path_append "${base_dotfilesprivate_dir}/bin"
  path_append "${base_dotfiles_dir}/bin"

  # Local bin (and it's subfolders)
  while IFS='' read -r -d '' the_path; do
    base=$(/usr/bin/basename "${the_path}")
    if [[ "${base}" != "optional" ]]; then
      path_append "${the_path}"
    fi
  done < <(/usr/bin/find "${base_bin_dir}" -maxdepth 1 -type d -print0)

  # WSL (Windows)
  path_append "${WIN_HOME:-${HOME}}/winfiles/bin"

  # Neovim Mason bin path (for all the linters and other dev tools)
  # I want this to be "first" among the dev language tooling so it takes precedence
  path_append "${base_data_dir}/nvim/mason/bin"

  # Flatpak
  #    Global packages
  path_append "/var/lib/flatpak/exports/bin"

  #    User packages
  path_append "${base_data_dir}/flatpak/exports/bin"

  # Tack the original system path back on to the end
  PATH="${PATH}:${path_system_original}"

  log "Path before mise activate: ${PATH}"

  if command_exists mise; then
    log "Mise found, calling activate."
    eval "$(mise activate bash)"

    # Some mise aliases
    alias ms="mise"
    alias msx="mise x --"
    alias misex="mise x --"
    alias msr="mise r --"
    alias miser="mise r --"

    # Mise Completion
    eval "$(mise completion bash)"
  else
    log "Mise not found, skipping activation."
  fi

  if command_exists uv; then
    path_append "${UV_TOOL_BIN_DIR:-}"
    uv tool update-shell &> /dev/null || true
  fi

  log "Final path after customizations and Mise activation: ${PATH}"
}

set_path
unset -f set_path
