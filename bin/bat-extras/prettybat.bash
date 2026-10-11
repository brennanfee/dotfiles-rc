#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# bat-extras | Copyright (C) 2019 eth-p | MIT License
#
# Repository: https://github.com/eth-p/bat-extras
# Issues:     https://github.com/eth-p/bat-extras/issues
# -----------------------------------------------------------------------------
# shellcheck disable=SC1090
# --- BEGIN LIBRARY FILE: opt.sh ---

# An array of functions to call before returning from `shiftopt`.
#
# If one of these functions returns a successful exit code, the
# option will be transparently skipped instead of handled.
SHIFTOPT_HOOKS=()

# A setting to change how `shiftopt` will interpret short options that consist
# of more than one character.
#
# Values:
#
#     SPLIT  -- Splits the option into multiple single-character short options.
#               "-abc" -> ("-a" "-b" "-c")
#
#     VALUE  -- Uses the remaining characters as the value for the short option.
#               "-abc" -> ("-a=bc")
#
#     CONV   -- Converts the argument to a long option.
#               "-abc" -> ("--abc")
#
#     PASS   -- Pass the argument along as-is.
#               "-abc" -> ("-abc")
#
SHIFTOPT_SHORT_OPTIONS="VALUE"

# Sets the internal _ARGV, _ARGV_INDEX, and _ARGV_LAST variables used when
# parsing options with the shiftopt and shiftval functions.
#
# Arguments:
#     ... -- The program arguments.
#
# Example:
#     setargs "--long=3" "file.txt"
setargs() {
  _ARGV=("$@")
  _ARGV_LAST="$((${#_ARGV[@]} - 1))"
  _ARGV_INDEX=0
  _ARGV_SUBINDEX=1
}

# Gets all the remaining unparsed arguments and saves them to a variable.
#
# Arguments:
#     "-a" -- Append the arguments to the variable instead of replacing it.
#     $1   -- The variable to save the args to.
#
# Example:
#     getargs remaining_args
getargs() {
  if [[ "$1" = "-a" || "$1" = "--append" ]]; then
    if [[ "${_ARGV_INDEX}" -ne "$((_ARGV_LAST + 1))" ]]; then
      eval "$2=(\"\${$2[@]}\" $(printf '%q ' "${_ARGV[@]:$_ARGV_INDEX}"))"
    fi
  else
    if [[ "${_ARGV_INDEX}" -ne "$((_ARGV_LAST + 1))" ]]; then
      eval "$1=($(printf '%q ' "${_ARGV[@]:$_ARGV_INDEX}"))"
    else
      eval "$1=()"
    fi
  fi
}

# Resets the internal _ARGV* variables to the original script arguments.
# This is the equivalent of storing the top-level $@ and using setargs with it.
resetargs() {
  setargs "${_ARGV_ORIGINAL[@]}"
}

# INTERNAL.
#
# Increments the argv index pointer used by `shiftopt`.
_shiftopt_next() {
  _ARGV_SUBINDEX=1
  ((_ARGV_INDEX++)) || true
}

# Gets the next option passed to the script.
#
# Variables:
#     OPT  -- The option name.
#
# Returns:
#     0  -- An option was read.
#     1  -- No more options were read.
#
# Example:
#     while shiftopt; do
#         shiftval
#         echo "$OPT = $OPT_VAL"
#     done
shiftopt() {
  # Read the top of _ARGV.
  [[ "$_ARGV_INDEX" -gt "$_ARGV_LAST" ]] && return 1
  OPT="${_ARGV[$_ARGV_INDEX]}"
  unset OPT_VAL

  if [[ "$OPT" =~ ^-[a-zA-Z0-9_-]+=.* ]]; then
    OPT_VAL="${OPT#*=}"
    OPT="${OPT%%=*}"
  fi

  # Handle short options.
  if [[ "$OPT" =~ ^-[^-]{2,} ]]; then
    case "$SHIFTOPT_SHORT_OPTIONS" in
      # PASS mode: "-abc=0" -> ("-abc=0")
      PASS) _shiftopt_next ;;

      # CONV mode: "-abc=0" -> ("--abc=0")
      CONV)
        OPT="-${OPT}"
        _shiftopt_next
        ;;

      # VALUE mode: "-abc=0" -> ("-a=bc=0")
      VALUE) {
        OPT="${_ARGV[$_ARGV_INDEX]}"
        OPT_VAL="${OPT:2}"
        OPT="${OPT:0:2}"
        _shiftopt_next
      } ;;

      # SPLIT mode: "-abc=0" -> ("-a=0" "-b=0" "-c=0")
      SPLIT) {
        OPT="-${OPT:$_ARGV_SUBINDEX:1}"
        ((_ARGV_SUBINDEX++)) || true
        if [[ "$_ARGV_SUBINDEX" -gt "${#OPT}" ]]; then
          _shiftopt_next
        fi
      } ;;

      # ????? mode: Treat it as pass.
      *)
        printf "shiftopt: unknown SHIFTOPT_SHORT_OPTIONS mode '%s'" \
          "$SHIFTOPT_SHORT_OPTIONS" 1>&2
        _shiftopt_next
        ;;
    esac
  else
    _shiftopt_next
  fi

  # Handle hooks.
  local hook
  for hook in "${SHIFTOPT_HOOKS[@]}"; do
    if "$hook"; then
      shiftopt
      return $?
    fi
  done

  return 0
}

# Gets the value for the current option.
#
# Variables:
#     OPT_VAL  -- The option value.
#
# Returns:
#     0       -- An option value was read.
#     EXIT 1  -- No option value was available.
shiftval() {
  # Skip if a value was already provided.
  if [[ -n "${OPT_VAL+x}" ]]; then
    return 0
  fi

  if [[ "$_ARGV_SUBINDEX" -gt 1 && "$SHIFTOPT_SHORT_OPTIONS" = "SPLIT" ]]; then
    # If it's a short group argument in SPLIT mode, we grab the next argument.
    OPT_VAL="${_ARGV[$((_ARGV_INDEX + 1))]}"
  else
    # Otherwise, we can handle it normally.
    OPT_VAL="${_ARGV[$_ARGV_INDEX]}"
    _shiftopt_next
  fi

  # Error if no value is provided.
  if [[ "$OPT_VAL" =~ -.* ]]; then
    printc "%{RED}%s: '%s' requires a value%{CLEAR}\n" "prettybat" "$ARG"
    exit 1
  fi
}

setargs "$@"
_ARGV_ORIGINAL=("$@")
# --- END LIBRARY FILE ---
# --- BEGIN LIBRARY FILE: opt_hook_version.sh ---

# Option parser hook: --version support.
# This will accept --version, which prints the version information and exits.
hook_version() {
  SHIFTOPT_HOOKS+=("__shiftopt_hook__version")
  __shiftopt_hook__version() {
    if [[ "$OPT" = "--version" ]]; then
      printf "%s %s\n\n%s\n%s\n" \
        "prettybat" \
        "2024.08.24" \
        "Copyright (C) 2019-2021 eth-p | MIT License" \
        "https://github.com/eth-p/bat-extras"
      exit 0
    fi

    return 1
  }
}
# --- END LIBRARY FILE ---
# --- BEGIN LIBRARY FILE: str.sh ---

# Converts a string to lower case.
tolower() {
  tr "[:upper:]" "[:lower:]" <<< "$1"
}

# Converts a string to upper case.
toupper() {
  tr "[:lower:]" "[:upper:]" <<< "$1"
}
# --- END LIBRARY FILE ---
# --- BEGIN LIBRARY FILE: print.sh ---

# Printf, but with optional colors.
# This uses the same syntax and arguments as printf.
#
# Example:
#     printc "%{RED}This is red %s.%{CLEAR}\n" "text"
#
printc() {
  printf "$(sed "$_PRINTC_PATTERN" <<< "$1")" "${@:2}"
}

# Initializes the color tags for printc.
#
# Arguments:
#     true  -- Turns on color output.
#     false -- Turns off color output.
printc_init() {
  case "$1" in
    true) _PRINTC_PATTERN="$_PRINTC_PATTERN_ANSI" ;;
    false) _PRINTC_PATTERN="$_PRINTC_PATTERN_PLAIN" ;;

    "[DEFINE]") {
      _PRINTC_PATTERN_ANSI=""
      _PRINTC_PATTERN_PLAIN=""

      local name
      local ansi
      while read -r name ansi; do
        if [[ -z "${name}" && -z "${ansi}" ]] || [[ "${name:0:1}" = "#" ]]; then
          continue
        fi

        ansi="${ansi/\\/\\\\}"

        _PRINTC_PATTERN_PLAIN="${_PRINTC_PATTERN_PLAIN}s/%{${name}}//g;"
        _PRINTC_PATTERN_ANSI="${_PRINTC_PATTERN_ANSI}s/%{${name}}/${ansi}/g;"
      done

      if [[ -t 1 && -z "${NO_COLOR+x}" ]]; then
        _PRINTC_PATTERN="$_PRINTC_PATTERN_ANSI"
      else
        _PRINTC_PATTERN="$_PRINTC_PATTERN_PLAIN"
      fi
    } ;;
  esac
}

# Print a warning message to stderr.
# Arguments:
#     1   -- The printc formatting string.
#     ... -- The printc formatting arguments.
print_warning() {
  printc "%{YELLOW}[%s warning]%{CLEAR}: $1%{CLEAR}\n" "prettybat" "${@:2}" 1>&2
}

# Print an error message to stderr.
# Arguments:
#     1   -- The printc formatting string.
#     ... -- The printc formatting arguments.
print_error() {
  printc "%{RED}[%s error]%{CLEAR}: $1%{CLEAR}\n" "prettybat" "${@:2}" 1>&2
}

# Initialization:
printc_init "[DEFINE]" << END
	CLEAR	\x1B[0m
	RED		\x1B[31m
	GREEN	\x1B[32m
	YELLOW	\x1B[33m
	BLUE	\x1B[34m
	MAGENTA	\x1B[35m
	CYAN	\x1B[36m

	DEFAULT \x1B[39m
	DIM		\x1B[2m
END
# --- END LIBRARY FILE ---
# --- BEGIN LIBRARY FILE: version.sh ---

# Gets the current bat version.
bat_version() {
  if [[ -z "${__BAT_VERSION}" ]]; then
    __BAT_VERSION="$(command "bat" --version | cut -d ' ' -f 2)"
  fi

  echo "${__BAT_VERSION}"
}

# Compares two version strings.
# Arguments:
#    1  -- The version to compare.
#    2  -- The comparison operator (same as []).
#    3  -- The version to compare with.
version_compare() {
  local version="$1"
  local compare="$3"

  if ! [[ "$version" =~ \.$ ]]; then
    version="${version}."
  fi

  if ! [[ "$compare" =~ \.$ ]]; then
    compare="${compare}."
  fi

  version_compare__recurse "$version" "$2" "$compare"
  return $?
}

version_compare__recurse() {
  local version="$1"
  local operator="$2"
  local compare="$3"

  # Extract the leading number.
  local v_major="${version%%.*}"
  local c_major="${compare%%.*}"

  # Extract the remaining numbers.
  local v_minor="${version#*.}"
  local c_minor="${compare#*.}"

  # Compare the versions specially if the final number has been reached.
  if [[ -z "$v_minor" && -z "$c_minor" ]]; then
    [ "$v_major" $operator "$c_major" ]
    return $?
  fi

  # Insert zeroes where there are missing numbers.
  if [[ -z "$v_minor" ]]; then
    v_minor="0."
  fi

  if [[ -z "$c_minor" ]]; then
    c_minor="0."
  fi

  # Compare the versions.
  # This is an early escape case.
  case "$operator" in
    -eq) [[ "$v_major" -ne "$c_major" ]] && return 1 ;;
    -ne) [[ "$v_major" -ne "$c_major" ]] && return 0 ;;
    -ge | -gt)
      [[ "$v_major" -lt "$c_major" ]] && return 1
      [[ "$v_major" -gt "$c_major" ]] && return 0
      ;;
    -le | -lt)
      [[ "$v_major" -gt "$c_major" ]] && return 1
      [[ "$v_major" -lt "$c_major" ]] && return 0
      ;;
  esac

  version_compare__recurse "$v_minor" "$operator" "$c_minor"
}
# --- END LIBRARY FILE ---
# --- BEGIN LIBRARY FILE: check.sh ---

# Checks that the file or directory exists.
# Arguments:
#    1  -- The path to check.
check_exists() {
  [[ -e "$1" ]] && return 0

  print_error "%s: No such file or directory" "$1"
  return 1
}

# Checks that the file is a file.
# Arguments:
#    1  -- The path to check.
check_is_file() {
  [[ -f "$1" ]] && return 0

  print_error "%s: Not a file" "$1"
  return 1
}
# --- END LIBRARY FILE ---
# --- BEGIN LIBRARY FILE: term.sh ---

# Gets the width of the terminal.
# This will return 80 unless stdin is attached to the terminal.
#
# Returns:
#     The terminal width, or 80 if there's no TTY.
#
term_width() {
  # shellcheck disable=SC2155
  local width="$({ stty size 2> /dev/null || echo "22 80"; } | cut -d ' ' -f2)"
  if [[ "$width" -ne 0 ]]; then
    echo "$width"
  else
    echo "80"
  fi
  return 0
}

# Clears the terminal using the ANSI escape sequences for erase screen and cursor absolute positioning.
term_clear() {
  printf "\x1B[3J\x1B[2J\x1B[H"
}
# --- END LIBRARY FILE ---
# -----------------------------------------------------------------------------
# Init:
# -----------------------------------------------------------------------------
hook_version
# -----------------------------------------------------------------------------
# Formatters:
# -----------------------------------------------------------------------------

FORMATTERS=(
  "yq" "prettier" "rustfmt" "shfmt" "clangformat"
  "black" "mix_format" "column"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

formatter_prettier_supports() {
  case "$1" in
    .js | .jsx | \
      .ts | .tsx | \
      .css | .scss | .sass | \
      .graphql | .gql | \
      .html | .svg | \
      .json | \
      .md | \
      .yml)
      return 0
      ;;
  esac

  return 1
}

formatter_prettier_process() {
  # Rewrite the file extension to hackily support SVG.
  local file="$1"
  local fext="$(extname "$file")"
  case "$fext" in
    .svg) file="$(basename -- "$file" "$fext").html" ;;
  esac

  prettier --stdin --stdin-filepath "$file" 2> /dev/null
  return $?
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

formatter_clangformat_supports() {
  case "$1" in
    .c | .cpp | .cxx | \
      .h | .hpp | \
      .m)
      return 0
      ;;
  esac

  return 1
}

formatter_clangformat_process() {
  clang-format "$1" 2> /dev/null
  return $?
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

formatter_rustfmt_supports() {
  [[ "$1" = ".rs" ]]
  return $?
}

formatter_rustfmt_process() {
  rustfmt
  return $?
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

formatter_shfmt_supports() {
  [[ "$1" = ".sh" ]]
  return $?
}

formatter_shfmt_process() {
  shfmt
  return $?
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

formatter_black_supports() {
  case "$1" in
    .py | \
      .py3 | \
      .pyw | \
      .pyi)
      return 0
      ;;
  esac

  return 1
}

formatter_black_process() {
  black --code "$(cat -)"
  return $?
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

formatter_mix_format_supports() {
  case "$1" in
    .ex | \
      .exs | \
      .eex | \
      .heex)
      return 0
      ;;
  esac

  return 1
}

formatter_mix_format_process() {
  mix format
  return $?
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

formatter_column_supports() {
  case "$1" in
    .tsv)
      return 0
      ;;
  esac

  return 1
}

formatter_column_process() {
  local needs_newline=true
  local args=(
    -t
    -s $'\t'
    -c "$TERMINAL_WIDTH"
  )

  if column --help &> /dev/null; then
    # GNU `column`
    args+=(--keep-empty-lines)
    needs_newline=false
  fi

  { { "$needs_newline" && sed 's/$/\n/'; } || cat; } | column "${args[@]}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

formatter_yq_supports__version_ok() {
  local yq_version
  yq_version=$(yq --version | sed 's/^.* version v//')

  # If it's older than yq version 4, replace the functions to save processing.
  if version_compare "$yq_version" -lt 4.0; then
    formatter_yq_supports() { return 1; }
    formatter_yq_supports__version_ok() { return 1; }
    return 1
  fi

  # It's supported.
  formatter_yq_supports__version_ok() { return 0; }
  return 0
}

formatter_yq_supports() {
  case "$1" in
    .yaml | yml | \
      .json)
      formatter_yq_supports__version_ok
      return $?
      ;;
  esac

  return 1
}

formatter_yq_process() {
  local args=()
  case "$1" in
    *.json) args+=(--output-format json) ;;
  esac

  yq --prettyPrint --indent 4 "${args[@]}" \
    | sed -e ':l' -e 's/^\(\t*\)    /\1\t/g; t l'
  return $?
}

# -----------------------------------------------------------------------------
# Functions:
# -----------------------------------------------------------------------------

# This function will map a bat `--language=...` argument into an appropriate
# file extension for the language provided. This should be hardcoded for
# performance reasons.
map_language_to_extension() {
  local ext=".txt"

  case "$1" in
    sh | bash) ext=".sh" ;;
    js | es6 | es) ext=".js" ;;
    jsx) ext=".jsx" ;;
    ts) ext=".ts" ;;
    tsx) ext=".tsx" ;;
    css) ext=".css" ;;
    scss) ext=".scss" ;;
    sass) ext=".sass" ;;
    svg) ext=".svg" ;;
    html | htm | shtml | xhtml) ext=".html" ;;
    json) ext=".json" ;;
    md | mdown | markdown) ext=".md" ;;
    yaml | yml) ext=".yml" ;;
    rust | rs) ext=".rs" ;;
    graphql | gql) ext=".graphql" ;;
    python | py) ext=".py" ;;
    elixir | ex) ext=".ex" ;;
    exs) ext=".exs" ;;
    tsv) ext=".tsv" ;;
  esac

  echo "$ext"
}

# This function will map a file extension to a formatter.
# Formatters are defined higher up in the file.
map_extension_to_formatter() {
  local formatter
  for formatter in "${FORMATTERS[@]}"; do
    if "formatter_${formatter}_supports" "$1"; then
      echo "$formatter"
      return 0
    fi
  done

  echo "none"
  return 0
}

extname() {
  local file="$1"
  echo ".${file##*.}"
}

print_file() {
  if [[ "${#PRINT_ARGS[@]}" -eq 0 ]]; then
    "bat" "$@"
    return $?
  else
    "bat" "${PRINT_ARGS[@]}" "$@"
    return $?
  fi
}

process_file() {
  PRINT_ARGS=("${BAT_ARGS[@]}")
  local file="$1"
  local ext="$2"
  local fext="$ext"
  local lang="${ext:1}"
  local formatter

  # Check that the file exists, and is a file.
  if [[ "$file" != "-" ]]; then
    check_exists "$file" || return 1
    check_is_file "$file" || return 1
  fi

  # Determine the formatter.
  if [[ -n "$OPT_LANGUAGE" ]]; then
    lang="$OPT_LANGUAGE"
    fext="$(map_language_to_extension "$lang")"
  fi

  if [[ "$ext" != "-" ]]; then
    formatter="$(map_extension_to_formatter "$fext")"
  fi

  # Debug: Print the name and formatter.
  if "$DEBUG_PRINT_FORMATTER"; then
    printc "%{CYAN}%s%{CLEAR}: %s\n" "$file" "$formatter"
    return 0
  fi

  # Calculate additional print arguments.
  forward_file_name "$file"

  # Print the formatted file.
  if [[ "$formatter" = "none" ]]; then
    if [[ -z "$OPT_LANGUAGE" ]]; then
      print_file "$file"
    else
      print_file --language="$OPT_LANGUAGE" "$file"
    fi
    return $?
  fi

  # Prettify, then print.
  local data_raw
  local data_formatted

  # shellcheck disable=SC2094 disable=SC2181
  if [[ "$file" = "-" ]]; then
    data_raw="$(cat -)"
    data_formatted="$("formatter_${formatter}_process" "STDIN${fext}" 2> /dev/null <<< "$data_raw")"

    if [[ $? -ne 0 ]]; then
      print_warning "'STDIN': Unable to format with '%s'" "$formatter"
      print_file --language="$lang" - <<< "$data_raw"
      return 1
    fi
  else
    data_formatted="$("formatter_${formatter}_process" "$file" < "$file")"

    if [[ $? -ne 0 ]]; then
      print_warning "'%s': Unable to format with '%s'" "$file" "$formatter"
      print_file --language="$lang" "$file"
      return 1
    fi
  fi

  print_file --language="$lang" - <<< "$data_formatted"
  return $?
}

# -----------------------------------------------------------------------------
# Version-Specific Features:
# -----------------------------------------------------------------------------
BAT_VERSION="$(bat_version)"

forward_file_name() { :; }

if version_compare "$BAT_VERSION" -ge "0.14"; then
  forward_file_name() {
    PRINT_ARGS+=("--file-name" "$1")
  }
fi

# -----------------------------------------------------------------------------
# Main:
# -----------------------------------------------------------------------------
BAT_ARGS=()
OPT_LANGUAGE=
FILES=()
DEBUG_PRINT_FORMATTER=false

TERMINAL_WIDTH="$(term_width)"

# Parse arguments.
while shiftopt; do
  case "$OPT" in

    # Language options
    -l)
      shiftval
      OPT_LANGUAGE="${OPT_VAL}"
      ;;
    -l*) OPT_LANGUAGE="${OPT:2}" ;;
    --language)
      shiftval
      OPT_LANGUAGE="$OPT_VAL"
      ;;

    # Debug options
    --debug:formatter) DEBUG_PRINT_FORMATTER=true ;;

    # Read from stdin
    -) FILES+=("-") ;;

    # bat options
    -*) {
      if [[ -n "$OPT_VAL" ]]; then
        BAT_ARGS+=("$OPT=$OPT_VAL")
      else
        BAT_ARGS+=("$OPT")
      fi
    } ;;

    # Files
    *) {
      FILES+=("$OPT")
    } ;;

  esac
done

if [[ "${#FILES[@]}" -eq 0 ]]; then
  FILES=("-")
fi

# Handle input files.
FAIL=0
for file in "${FILES[@]}"; do
  if ! process_file "$file" "$(tolower "$(extname "$file")")"; then
    FAIL=1
  fi
done

# Exit.
exit "$FAIL"
