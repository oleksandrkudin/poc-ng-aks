#!bash

function help () {
  cat <<- EOT
Usage: $(basename $0) [options...] [<tfstate-layer-path>]

Create tfstate layer. By default path is set to src/terragrunt/tfstate directory.

Options:
  -h, --help            Show this help output
EOT
}

if options=$(getopt --options h --longoptions help -- "$@"); then
  eval set -- "$options"
  while true; do
    case "$1" in
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

TFSTATE_LAYER_PATH=${1:-"src/terragrunt/tfstate"}

terragrunt run-all apply -auto-approve -var create_all=true --terragrunt-working-dir $TFSTATE_LAYER_PATH