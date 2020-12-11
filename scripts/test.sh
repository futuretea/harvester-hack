#!/usr/bin/env bash
[[ -n $DEBUG ]] && set -x
set -eou pipefail

useage() {
    cat <<HELP
USAGE:
    test.sh
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
ROOT_DIR=${3:-$GIT_ROOT_DIR}

mkdir -p "${ROOT_DIR}/dist"
echo  "Running unit tests"
unit_test_targets=($(find "${ROOT_DIR}/pkg" -type d -maxdepth 1 -mindepth 1 ! -path '*generated*' ! -path '*apis*' -exec echo {}/... \;))
CGO_ENABLED=0 go test -tags=test -cover -coverprofile "${ROOT_DIR}/dist/coverage.out" \
                            "${unit_test_targets[@]}"


