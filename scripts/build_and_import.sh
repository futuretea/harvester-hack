#!/usr/bin/env bash
[[ -n $DEBUG ]] && set -x
set -eou pipefail

usage() {
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
    usage
    exit 1
fi

GIT_COMMIT_ID=$(git rev-parse --short HEAD)
GIT_ROOT_DIR=$(git rev-parse --show-toplevel)
ROOT_DIR=$GIT_ROOT_DIR

SSH_HOST=$1
BIN_DIR=${2:-"bin"}
BIN_NAME=${3:-"harvester"}
IMAGE_NAME=${4:-"futuretea/$BIN_NAME:$GIT_COMMIT_ID"}
TAR_NAME="$BIN_NAME-$GIT_COMMIT_ID.tar"
DOCKER_DIR=${5:-"futuretea/docker"}
BUILD_SCRIPT=${6:-"./scripts/build"}
IMPORT_CMD=${7:-"sudo k3s ctr images import"}


# build bin
$BUILD_SCRIPT
# build image
cd "$DOCKER_DIR"
cp "$ROOT_DIR/$BIN_DIR/$BIN_NAME" .
docker build -t "$IMAGE_NAME" .
docker save "$IMAGE_NAME" -o "$TAR_NAME"
# import image
scp ./"$TAR_NAME" "${SSH_HOST}":/tmp
ssh "$SSH_HOST" "$IMPORT_CMD" /tmp/"$TAR_NAME"
kubectl -n harvester-system set image deployment/"$BIN_NAME" apiserver="$IMAGE_NAME"
