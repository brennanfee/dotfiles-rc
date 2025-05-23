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

dotfiles_dir=$(xdg_base_dir DOTFILES)
base_data_dir=$(xdg_base_dir DATA)
base_state_dir=$(xdg_base_dir STATE)
base_config_dir=$(xdg_base_dir CONFIG)

log "Path before mise activate: ${PATH}"

if command_exists mise; then
  log "Mise found, calling CUSTOM activate."
  source_or_error "${dotfiles_dir}/bash/assets/custom_mise_activate.bash"
  # if [[ -n "${GHOSTTY_RESOURCES_DIR}" && -x "${dotfiles_dir}/bash/assets/custom_mise_activate.bash" ]]; then
  #   log "Loading CUSTOM Mise activate."
  #   source_or_error "${dotfiles_dir}/bash/assets/custom_mise_activate.bash"
  # else
  #   log "Loading traditional Mise activate."
  #   eval "$(mise activate bash)"
  # fi

  log "Path after mise activate: ${PATH}"

  # Some mise aliases
  alias mx="mise x --"
  alias mr="mise r --"

  export RUSTUP_INIT_SKIP_PATH_CHECK="yes"
  export RUSTUP_HOME="${base_state_dir}/rustup"
  export MISE_RUSTUP_HOME="${base_state_dir}/rustup"
  export CARGO_HOME="${base_data_dir}/cargo"
  export MISE_CARGO_HOME="${base_data_dir}/cargo"

  export MISE_NODE_DEFAULT_PACKAGES_FILE="${base_config_dir}/mise/default-node-packages"
  export MISE_NODE_COREPACK="true"
else
  log "Mise not found, skipping Mise activate."
fi

unset base_data_dir
unset base_state_dir
unset base_config_dir
