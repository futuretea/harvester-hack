#!/usr/bin/env bash
[[ -n $DEBUG ]] && set -x
set -eou pipefail

useage() {
    cat <<HELP
USAGE:
    test-integration.sh
HELP
}

exit_err() {
    echo >&2 "${1}"
    exit 1
}

if [ $# -lt 0 ]; then
    useage
    exit 1
fi

GIT_ROOT_DIR=$(git rev-parse --show-toplevel)
ROOT_DIR=$GIT_ROOT_DIR

echo "Running integration tests"
CGO_ENABLED=0 ginkgo -r -v -trace -tags=test \
            -failFast -slowSpecThreshold=120 -timeout=30m  "${ROOT_DIR}/tests/integration/..."

