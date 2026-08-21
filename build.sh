#!/bin/bash

set -euo pipefail

IMAGE=glove80-zmk-config-docker
BRANCH="${1:-main}"

docker build -t "$IMAGE" -f Dockerfile
docker run --rm -v "$PWD:/config" -e UID="$(id -u)" -e GID="$(id -g)" -e BRANCH="$BRANCH" "$IMAGE"
