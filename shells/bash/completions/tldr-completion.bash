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

BUILTIN_THEMES="single base16 ocean"

OS_TYPES="linux osx sunos windows"

OPTIONS='-v
--version
-l
--list
-a
--list-all
-1
--single-column
-r
--random
-e
--random-example
-f
--render
-m
--markdown
-o
--linux
--osx
--sunos
--windows
-t
--theme
-s
--search
-u
--update
-c
--clear-cache
-h
--help'

function _tldr_autocomplete {
  OPTS_NOT_USED=$(comm -23 <(echo "${OPTIONS}" | sort || true) <(printf '%s\n' "${COMP_WORDS[@]}" | sort || true))

  cur="${COMP_WORDS[${COMP_CWORD}]}"
  COMPREPLY=()
  if [[ "${cur}" =~ ^-.* ]]; then
    # shellcheck disable=2207
    COMPREPLY=($(compgen -W "${OPTS_NOT_USED}" -- "${cur}"))
  else
    if [[ ${COMP_CWORD} -eq 0 ]]; then
      prev=""
    else
      prev=${COMP_WORDS[${COMP_CWORD} - 1]}
    fi
    case "${prev}" in
      -f | --render)
        # shellcheck disable=2207
        COMPREPLY=($(compgen -f "${cur}"))
        ;;

      -o | --os)
        # shellcheck disable=2207
        COMPREPLY=($(compgen -W "${OS_TYPES}" "${cur}"))
        ;;

      -t | --theme)
        # No suggestions for these, they take arbitrary values
        # shellcheck disable=2207
        SUGGESTED_BUILTINS=($(compgen -W "${BUILTIN_THEMES}" "${cur}"))
        if [[ ${#SUGGESTED_BUILTINS[@]} -eq 0 ]]; then
          COMPREPLY=()
        else
          COMPREPLY=("<custom theme name>" "${SUGGESTED_BUILTINS[@]}")
        fi
        ;;

      -s | --search)
        # No suggestions for these, they take arbitrary values
        COMPREPLY=("")
        ;;

      *)
        sheets=$(tldr -l -1)
        # shellcheck disable=2207
        COMPREPLY=($(compgen -W "${sheets} ${OPTS_NOT_USED}" -- "${cur}"))
        ;;
    esac
  fi
}

complete -F _tldr_autocomplete tldr
