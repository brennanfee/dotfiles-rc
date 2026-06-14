#!/usr/bin/env zsh

function setup_uv {
  # Export these regardless of whether uv is found, that way if uv is activated or used later
  # the settings will still be in place
  export INSTALLER_NO_MODIFY_PATH=1
  export UV_SYSTEM_CERTS="true"
  export UV_PYTHON_PREFERENCE="only-managed"

  if command -v uv &> /dev/null; then
    eval "$(uv generate-shell-completion zsh)"

    alias uvr="uv run"
  fi

  if command -v uvx &> /dev/null; then
    eval "$(uvx --generate-shell-completion zsh)"
  fi
}

setup_uv "#@"
unset -f setup_uv
