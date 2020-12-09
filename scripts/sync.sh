#!/bin/bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -L)"
export RSYNC_RSH="ssh -T -c aes128-ctr -o Compression=no -x"
SSH_CONFIG=${1:-"deku-tke-bak"}
DIST_DIR=${2:-"/home/deku/dev/futuretea/harvester/"}
rsync -avPr --delete --exclude-from="$ROOT_DIR/yuhang/scripts/exclude.list" ${ROOT_DIR}/ $SSH_CONFIG:$DIST_DIR
