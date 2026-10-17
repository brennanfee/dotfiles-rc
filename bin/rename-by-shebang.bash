#!/usr/bin/env bash
#
# Recursively rename extensionless files based on their shebang line:
#   bash shebang          -> <name>.bash
#   sh shebang            -> <name>.sh
#   zsh shebang           -> <name>.zsh
#   python or uv shebang  -> <name>.py
# Files whose shebang is missing or names another interpreter are left alone.
#
# Usage: rename-by-shebang.sh [-n] [directory]
#   -n  dry run: print what would be renamed without renaming anything
#   directory defaults to the current directory

set -euo pipefail

dry_run=false
if [[ ${1:-} == -n ]]; then
  dry_run=true
  shift
fi
root=${1:-.}

# Print "bash", "sh", "zsh", "py", or nothing, based on the file's first line.
shebang_ext() {
  local line interp
  IFS= read -r line < "$1" || [[ -n $line ]] || return 0
  line=${line%$'\r'}
  [[ $line =~ ^\#![[:space:]]*([^[:space:]]+)(.*)$ ]] || return 0
  interp=${BASH_REMATCH[1]##*/}

  # "#!/usr/bin/env [-S] [VAR=val ...] bash" -> take the first real word
  if [[ $interp == env ]]; then
    interp=""
    for word in ${BASH_REMATCH[2]}; do
      [[ $word == -* || $word == *=* ]] && continue
      interp=${word##*/}
      break
    done
  fi

  case $interp in
    bash) echo bash ;;
    sh) echo sh ;;
    zsh) echo zsh ;;
    python | python[0-9]* | uv) echo py ;;
  esac
}

# Skip hidden files/dirs (e.g. .git, .bashrc); only consider names with no dot.
find "$root" -mindepth 1 -name '.?*' -prune -o -type f ! -name '*.*' -print0 \
  | while IFS= read -r -d '' file; do
    ext=$(shebang_ext "$file")
    [[ -n $ext ]] || continue
    target="$file.$ext"
    if [[ -e $target ]]; then
      echo "skip: $file -> $target (target exists)" >&2
      continue
    fi
    if $dry_run; then
      echo "would rename: $file -> $target"
    else
      mv -n -- "$file" "$target"
      echo "renamed: $file -> $target"
    fi
  done
