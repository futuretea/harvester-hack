#!/usr/bin/env bash
[[ -n $DEBUG ]] && set -x
set -eou pipefail

useage() {
    cat <<HELP
USAGE:
    build.sh SSH_HOST
HELP
}

exit_err() {
    echo >&2 "${1}"
    exit 1
}

if [ $# -lt 1 ]; then
    useage
    exit 1
fi

SSH_HOST=$1
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -L)"
./scripts/build
cd yuhang/docker
cp $ROOT_DIR/bin/harvester .
docker build -t futuretea/harvester:master-head .
docker save futuretea/harvester:master-head -o futuretea-harvester.tar
scp ./futuretea-harvester.tar ${SSH_HOST}:/
ssh $SSH_HOST sudo k3s ctr images import /futuretea-harvester.tar
