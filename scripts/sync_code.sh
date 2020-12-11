#!/usr/bin/env bash
[[ -n $DEBUG ]] && set -x
set -eou pipefail

useage() {
    cat <<HELP
USAGE:
    sync.sh SSH_CONFIG DIST_DIR
HELP
}

exit_err() {
    echo >&2 "${1}"
    exit 1
}

if [ $# -lt 2 ]; then
    useage
    exit 1
fi
SSH_CONFIG=${1}
DIST_DIR=${2}
GIT_ROOT_DIR=$(git rev-parse --show-toplevel)
ROOT_DIR=${3:-$GIT_ROOT_DIR}
export RSYNC_RSH="ssh -T -c aes128-ctr -o Compression=no -x"
rsync -avPr --delete --exclude-from="$ROOT_DIR/exclude.list" ${ROOT_DIR}/ $SSH_CONFIG:$DIST_DIR
