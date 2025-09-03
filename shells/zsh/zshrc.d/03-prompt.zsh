#!/usr/bin/env zsh

function _custom_prompt_precmd {
  print ""
}

function setup_custom_prompt {
  autoload -Uz add-zsh-hook
  add-zsh-hook "precmd" _custom_prompt_precmd
  local newline=$'\n'
  PROMPT="${text_reset}${text_green}%n@%m ${text_magenta}%4~"
  PROMPT+="   ${text_red}(Starship is not installed)${text_reset}${newline}%# "
  RPROMPT="%D{%Y-%m-%d} %t"
}

function setup_prompt {
  if command_exists starship; then
    log "setting up starship for prompt"
    eval "$(starship init zsh)"
  else
    setup_custom_prompt
  fi

  # setup_custom_prompt
}

setup_prompt
unset -f setup_custom_prompt
unset -f setup_prompt
