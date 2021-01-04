#!/usr/bin/env bash
[[ -n $DEBUG ]] && set -x
set -eou pipefail

usage() {
    cat <<HELP
USAGE:
    test-integration.sh focus
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

FOCUS=$1
GIT_ROOT_DIR=$(git rev-parse --show-toplevel)
GIT_ROOT_DIR=.
ROOT_DIR=$GIT_ROOT_DIR

export USE_EXISTING_CLUSTER=true
export SKIP_HARVESTER_INSTALLATION=true
export DONT_USE_EMULATION=true
export KEEP_TESTING_CLUSTER=true
export KEEP_HARVESTER_INSTALLATION=true
export KEEP_TESTING_RESOURCE=false

echo "Running integration tests"
CGO_ENABLED=0 ginkgo -r -v -trace -tags=test \
            -failFast -slowSpecThreshold=120 -timeout=30m  \
            -focus="${FOCUS}" \
            "${ROOT_DIR}/tests/integration/..."

