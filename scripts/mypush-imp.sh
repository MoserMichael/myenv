#!/bin/bash

set -ex

Usage() {
cat <<EOF
Pushes the changes in git repo in current directory to github, using environment
variable GITHUB_USER and GITHUB_TOKEN
These environment variables must be set
EOF
    exit 1
}


if [[ $GITHUB_USER == "" ]]; then
    echo "Error: missing GITHUB_USER environment variable"
    Usage
fi

if [[ $GITHUB_TOKEN == "" ]]; then
    echo "Error: missing GITHUB_TOKEN environment variable"
    Usage
fi

FULL_REPO=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename "$FULL_REPO")


git push "https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo "*** repo ${REPO_NAME} pushed ***"
