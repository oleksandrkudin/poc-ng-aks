#!bash

function log_verbose () {
  if [ $VERBOSE -eq 1 ]; then
    echo "$@" >&2
  fi
}

function help () {
  cat <<- EOT
Usage: $(basename $0) [options...] [<layer-path>]

Provide list of layer components in JSON format. Components are searched by default in current directory.

Options:
  -v, --verbose         Make the operation more talkative
  -h, --help            Show this help output
EOT
}

if options=$(getopt --options vh --longoptions verbose,help -- "$@"); then
  eval set -- "$options"
  while true; do
    case "$1" in
      -v | --verbose)
        VERBOSE=1
        ;;
      -h | --help)
        help
        exit 0
        ;;
      --)
        shift
        break
        ;;
    esac
    shift
  done
else
  help
  exit 1
fi

VERBOSE=${VERBOSE:-0}
LAYER_PATH=${1:-"."}

log_verbose "Getting module groups ..."
module_groups="$(terragrunt output-module-groups --terragrunt-ignore-external-dependencies --terragrunt-working-dir $LAYER_PATH)"
log_verbose "$module_groups"

log_verbose "Creating list of modules ..."
raw_module_list="$(echo $module_groups | jq '[. | to_entries | .[].value] | flatten')"
log_verbose "$raw_module_list"

log_verbose "Converting absolute module path to name only ..."
module_list="$(echo $raw_module_list | jq  '[.[] | split("/") | last]')"
log_verbose "$module_list"

echo "$module_list" | jq '.' --compact-output