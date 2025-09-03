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
  local path_system_original path_core_additions the_path base

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

  # Temporarily add the mise shims directory, just so we can detect mise installed commands
  path_append "${mise_shims_dir}"

  log "Path befire mise check: ${PATH}"

  if command_exists uv; then
    path_append "${UV_TOOL_BIN_DIR:-}"
    uv tool update-shell &> /dev/null || true
  fi

  if command_exists coreutils; then
    if [[ -d "${base_bin_dir}/optional/coreutils" ]]; then
      path_prepend "${base_bin_dir}/optional/coreutils"
    fi
  fi

  if command_exists findutils; then
    if [[ -d "${base_bin_dir}/optional/findutils" ]]; then
      path_prepend "${base_bin_dir}/optional/findutils"
    fi
  fi

  if command_exists diffutils; then
    if [[ -d "${base_bin_dir}/optional/diffutils" ]]; then
      path_prepend "${base_bin_dir}/optional/diffutils"
    fi
  fi

  # Remove the temporarily added mise shim path
  path_remove "${mise_shims_dir}"

  path_core_additions="${PATH}"
  log "Path core additions: ${path_core_additions}"

  PATH="${path_core_additions}:${path_system_original}"

  log "Path after customizations: ${PATH}"

  # Now activate MISE "for real", this is the one that will stick around
  if command_exists mise; then
    log "Mise found, calling CUSTOM activate."
    source_or_error "${base_dotfiles_dir}/shells/bash/custom_mise_activate.bash"
    eval "$(mise hook-env -s bash)"

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

  log "Final after customizations and Mise activation: ${PATH}"
}

set_path
unset -f set_path
