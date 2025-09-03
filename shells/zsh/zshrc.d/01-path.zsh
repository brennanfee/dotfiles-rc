#!/usr/bin/env zsh

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
    log "Mise found, calling activate."
    eval "$(mise activate zsh)"
    eval "$(mise hook-env -s zsh)"

    # Some mise aliases
    alias ms="mise"
    alias msx="mise x --"
    alias misex="mise x --"
    alias msr="mise r --"
    alias miser="mise r --"

    # Mise Completion
    eval "$(mise completion zsh)"
  else
    log "Mise not found, skipping activation."
  fi

  # Ensure path arrays do not contain duplicates.
  typeset -gU path

  log "Final after customizations and Mise activation: ${PATH}"
}

set_path
unset -f set_path
