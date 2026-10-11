#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# bat-extras | Copyright (C) 2020 eth-p | MIT License
#
# Repository: https://github.com/eth-p/bat-extras
# Issues:     https://github.com/eth-p/bat-extras/issues
# -----------------------------------------------------------------------------
# shellcheck disable=SC1090
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
  printc "%{YELLOW}[%s warning]%{CLEAR}: $1%{CLEAR}\n" "bat-modules" "${@:2}" 1>&2
}

# Print an error message to stderr.
# Arguments:
#     1   -- The printc formatting string.
#     ... -- The printc formatting arguments.
print_error() {
  printc "%{RED}[%s error]%{CLEAR}: $1%{CLEAR}\n" "bat-modules" "${@:2}" 1>&2
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
    printc "%{RED}%s: '%s' requires a value%{CLEAR}\n" "bat-modules" "$ARG"
    exit 1
  fi
}

setargs "$@"
_ARGV_ORIGINAL=("$@")
# --- END LIBRARY FILE ---
# --- BEGIN LIBRARY FILE: opt_hook_color.sh ---

# Option parser hook: color support.
# This will accept --no-color or --color.
# It will also try to accept --color=never|always|auto.
#
# The variable OPT_COLOR will be set depending on whether or not a TTY is
# detected and whether or not --color/--no-color is specified.
hook_color() {
  SHIFTOPT_HOOKS+=("__shiftopt_hook__color")
  __shiftopt_hook__color() {
    case "$OPT" in

      --no-color) OPT_COLOR=false ;;
      --color) {
        case "$OPT_VAL" in
          "") OPT_COLOR=true ;;
          always | true) OPT_COLOR=true ;;
          never | false) OPT_COLOR=false ;;
          auto) return 0 ;;
          *)
            printc "%{RED}%s: '--color' expects value of 'auto', 'always', or 'never'%{CLEAR}\n" "bat-modules"
            exit 1
            ;;
        esac
      } ;;

      *) return 1 ;;
    esac

    printc_init "$OPT_COLOR"
    return 0
  }

  # Default color support.
  if [[ -z "$OPT_COLOR" ]]; then
    if [[ -t 1 ]]; then
      OPT_COLOR=true
    else
      OPT_COLOR=false
    fi
    printc_init "$OPT_COLOR"
  fi
}
# --- END LIBRARY FILE ---
# --- BEGIN LIBRARY FILE: opt_hook_version.sh ---

# Option parser hook: --version support.
# This will accept --version, which prints the version information and exits.
hook_version() {
  SHIFTOPT_HOOKS+=("__shiftopt_hook__version")
  __shiftopt_hook__version() {
    if [[ "$OPT" = "--version" ]]; then
      printf "%s %s\n\n%s\n%s\n" \
        "bat-modules" \
        "2024.08.24" \
        "Copyright (C) 2019-2021 eth-p | MIT License" \
        "https://github.com/eth-p/bat-extras"
      exit 0
    fi

    return 1
  }
}
# --- END LIBRARY FILE ---
# --- BEGIN LIBRARY FILE: dsl.sh ---

# Parses a DSL file.
#
# Arguments:
#     1  -- The DSL file.
dsl_parse_file() {
  dsl_parse < "$1"
  return $?
}

# Parses DSL data.
# This calls callback functions to handle the parsed data:
#
# Format:
#    | command arg1 arg2
#    |     option arg1 arg2
#
# Callbacks:
#     dsl_on_raw     "$indent" "$line"               -- Called after every line.
#     dsl_on_command "$command" "$arg1" "$arg2" ...  -- Called on command lines.
#     dsl_on_command_commit                          -- Called after commands and their options.
#     dsl_on_option  "$option" "$arg1" "$arg2" ...   -- Called on option lines.
#
# Variables:
#     DSL_LINE_NUMBER -- The line number being parsed at the time of a callback.
#     DSL_COMMAND     -- The command being parsed at the time of a callback.
#
# Input:
#     The DSL data to parse.
dsl_parse() {
  local line
  local line_raw
  local line_fields
  local indent
  local command

  DSL_LINE_NUMBER=0
  DSL_COMMAND=''
  while IFS='' read -r line_raw; do
    ((DSL_LINE_NUMBER++)) || true

    # Parse the indentation.
    # If the indentation is greater than zero, it's considered an option.
    [[ "$line_raw" =~ ^(	|[[:space:]]{2,}) ]] || true
    indent="${BASH_REMATCH[1]}"
    line="${line_raw:${#indent}}"

    if [[ -n "$line" ]] && ! [[ "$line" =~ ^# ]]; then
      # Parse the line items.
      eval "$(dsl_parse_line <<< "$line")"

      # Call the appropriate on_* function.
      if [[ "${#indent}" -eq 0 ]]; then
        if [[ -n "$DSL_COMMAND" ]]; then
          dsl_on_command_commit
        fi

        DSL_COMMAND="${line_fields[0]}"
        dsl_on_command "${line_fields[@]}"
      else
        dsl_on_option "${line_fields[@]}"
      fi
    fi

    # Call the on_raw function.
    # This function can be used to echo back a line to rewrite the file.
    dsl_on_raw "$indent" "$line"
  done

  if [[ -n "$DSL_COMMAND" ]]; then
    dsl_on_command_commit
  fi

  return 0
}

# Parses a line into fields.
# This parses fields with a bash-like command parameter syntax:
#
# "arg 1" "" arg3
#
# Input:
#     The line to parse.
#
# Output:
#     A series of bash statemtents that write the fields into an array named "line_fields".
dsl_parse_line() {
  awk '
		{
			print "line_fields=()"
			n=0
			buffer=""
			quoted=0
			while ($0 != "") {
				quoted_once=0
				while ($0 != "") {
					# Match " ", "\", or quote.
					if (!match($0, /[\t \\"]/)) {
						buffer=sprintf("%s%s", buffer, $0)
						$0=""
						break
					}

					# Extract the character and previous literal string.
					buffer=sprintf("%s%s", buffer, substr($0, 0, RSTART - 1))
					chr=substr($0, RSTART, RLENGTH)
					$0=substr($0, RSTART + RLENGTH)

					# Handle the matched character.
					if (chr == "\\") {
						buffer=sprintf("%s%s", buffer, substr($0, 0, 1))
						$0=substr($0, 2)
						continue
					}

					if (chr == "\"") {
						quoted=!quoted
						quoted_once=1
						continue
					}

					if ((chr == " " || chr == "\t") && quoted) {
						buffer=sprintf("%s ", buffer)
						continue
					}

					break
				}

				# If the buffer is empty and it is not intentionally empty,
				# it should not be considered a separate field.
				if (buffer == "" && !quoted_once) {
					continue
				}

				# Escape the parsed value.
				sub(/"/, "\\\"", buffer)
				sub(/\$/, "\\$", buffer)

				# Print the parsed value.
				print sprintf("line_fields[%s]=\"%s\"", n, buffer)
				buffer=""
				n=n+1
			}
		}
	'
}

dsl_on_raw() {
  # Stub
  :
}

#
#dsl_on_command() {
#	:
#}
#
#dsl_on_command_commit() {
#	:
#}
#
#dsl_on_option() {
#	:
#}
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
# -----------------------------------------------------------------------------
# Init:
# -----------------------------------------------------------------------------
hook_color
hook_version
# -----------------------------------------------------------------------------
COMMON_URL_GITHUB="https://github.com/%s.git"
COMMON_URL_GITLAB="https://gitlab.com/%s.git"
CONFIG_DIR="$(bat --config-dir)"
SYNTAX_DIR="${CONFIG_DIR}/syntaxes"
THEME_DIR="${CONFIG_DIR}/themes"
MODULES_FILE="${CONFIG_DIR}/modules.txt"
# -----------------------------------------------------------------------------
# Options:
# -----------------------------------------------------------------------------
ACTION="help"

# Parse arguments.
while shiftopt; do
  case "$OPT" in

    --help) ACTION="help" ;;
    --update) ACTION="update" ;;
    --clear) ACTION="clear" ;;
    --setup) ACTION="setup" ;;
    --modules-file) ACTION="show_file" ;;

    # ???
    -*) {
      printc "%{RED}%s: unknown option '%s'%{CLEAR}\n" "bat-modules" "$OPT" 1>&2
      exit 1
    } ;;

  esac
done

# -----------------------------------------------------------------------------
# Functions:
# -----------------------------------------------------------------------------

# Ensures that the modules file at $MODULES_FILE exists.
# If it doesn't, this will print a friendly warning and exit with exit code 1.
#
# This will also make sure the syntaxes and themes directories exist.
ensure_setup() {
  if ! [[ -f "$MODULES_FILE" ]]; then
    printc "%{YELLOW}The bat-modules modules file wasn't found.%{CLEAR}\n"
    printc "%{YELLOW}Use %{CLEAR}%s --setup%{YELLOW} to set up bat-modules, or%{CLEAR}\n" "bat-modules"
    printc "%{YELLOW}read the documentation at %{CLEAR}%s%{YELLOW} for more info.%{CLEAR}\n" "https://github.com/eth-p/bat-extras"
    exit 1
  fi

  mkdir -p "${SYNTAX_DIR}" &> /dev/null || true
  mkdir -p "${THEME_DIR}" &> /dev/null || true
}

# Prints an error message that parsing
fail_parsing() {
  print_warning "Failed to parse bat-modules file."
  print_warning "Line %s: %s" "$DSL_LINE" "$1"
  exit 1
}

# -----------------------------------------------------------------------------
# Parsing:
# -----------------------------------------------------------------------------

dsl_on_command() {
  BM_TYPE="$(tolower "$1")"
  BM_SOURCE="$(parse_source "$2")"
  BM_OPT_CHECKOUT="master"

  case "$BM_TYPE" in
    "syntax" | "theme") : ;;
    *) fail "unknown module type '$BM_TYPE'" ;;
  esac
}

dsl_on_option() {
  # Common options.
  case "$(tolower "$1")" in
    checkout)
      BM_OPT_CHECKOUT="$2"
      return 0
      ;;
  esac

  # Type-specific options.
  case "$BM_TYPE" in
    "syntax") on_option_for_syntax "$@" && return 0 ;;
    "theme") on_option_for_theme "$@" && return 0 ;;
  esac

  # Unknown options.
  fail "unknown %s option '%s'" "$BM_TYPE" "$*"
}

on_option_for_syntax() {
  :
}

on_option_for_theme() {
  :
}

# Parses a module source.
# This takes a git url or pseudo-URL patterns such as:
#
#     example/my-syntax-on-github
#     github:example/my-syntax
#     gitlab:example/my-syntax
#
# Arguments:
#     1  -- The source string.
parse_source() {
  local source="$1"

  # shellcheck disable=SC2059
  case "$source" in
    "github:"* | "gh:"*)
      source="$(printf "$COMMON_URL_GITHUB" "$(cut -d':' -f2- <<< "$source")")"
      ;;

    "gitlab:"* | "gl:"*)
      source="$(printf "$COMMON_URL_GITLAB" "$(cut -d':' -f2- <<< "$source")")"
      ;;

    *)
      if [[ "$1" =~ ^([A-Za-z0-9-])+/([A-Za-z0-9-])+$ ]]; then
        parse_source "github:$1" "${@:2}"
        return $?
      fi
      ;;
  esac

  echo "$source"
}

# Parses the clone directory name of a git repo URL.
# Arguments:
#     1  -- The repo URL.
parse_source_name() {
  basename "$1" .git
}

# -----------------------------------------------------------------------------
# Actions:
# -----------------------------------------------------------------------------

action:show_file() {
  printf "%s\n" "$MODULES_FILE"
}

action:setup() {
  if ! [[ -f "$MODULES_FILE" ]]; then
    cat > "$MODULES_FILE" << EOF
# bat-modules example file.
# See https://github.com/eth-p/bat-extras for documentation and help.

# syntax example/syntax

# theme https://github.com/example/theme.git
#     checkout abcdef1

EOF
  fi
  "${EDITOR:-vi}" "$MODULES_FILE"
}

action:help() {
  {
    printc "%{YELLOW}%s help:%{CLEAR}\n" "bat-modules"
    printc "  --clear         -- Clear the cached themes and syntaxes.\n"
    printc "  --update        -- Update themes and syntaxes.\n"
    printc "  --setup         -- Edit the bat-modules modules.txt file.\n"
    printc "  --modules-file  -- Show the bat-modules modules.txt file.\n"
  } 1>&2
}

action:clear() {
  printc "%{YELLOW}Clearing bat syntax and theme cache...%{CLEAR}\n"
  "bat" cache --clear
}

action:update() {
  CHANGES=false

  dsl_on_command_commit() {
    case "$BM_TYPE" in
      syntax) cd "$SYNTAX_DIR" ;;
      theme) cd "$THEME_DIR" ;;
    esac

    local hash
    local name="$(parse_source_name "$BM_SOURCE")"
    printc "%{BLUE}----- %s: %s -----%{CLEAR}\n" "$BM_TYPE" "$name"

    # If it isn't cloned, clone it.
    if ! [[ -d "$name" ]]; then
      printc "%{YELLOW}Cloning...%{CLEAR}\n"
      "git" clone "$BM_SOURCE" "$name"
      CHANGES=true
    fi

    # If it is cloned, fetch/checkout.
    printc "%{YELLOW}Updating...%{CLEAR}\n"
    cd "$name"
    hash="$("git" rev-parse HEAD)"
    "git" fetch origin --quiet
    "git" checkout "$BM_OPT_CHECKOUT" --quiet
    hash_new="$("git" rev-parse HEAD)"

    if [[ "$hash" != "$hash_new" ]]; then
      printc "%{YELLOW}Updated to %s.%{CLEAR}\n" "$hash_new"
      CHANGES=true
    fi
  }

  # Parse the DSL.
  ensure_setup
  dsl_parse_file "$MODULES_FILE"

  # If there are changes, update.
  printc "%{BLUE}----- bat-modules -----%{CLEAR}\n" "$BM_TYPE" "$name"
  printc "%{YELLOW}Done.%{CLEAR}\n"
  if "$CHANGES"; then
    printc "%{YELLOW}Rebuilding cache...%{CLEAR}\n"
    "bat" cache --build
  fi
}

# -----------------------------------------------------------------------------
# Main:
# -----------------------------------------------------------------------------
action:"$ACTION"
exit $?
