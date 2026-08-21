#!/bin/bash

set -euo pipefail

IMAGE=glove80-zmk-config-docker
BRANCH="${1:-main}"

docker build -t "$IMAGE" -f Dockerfile
docker run --rm --userns=host -v "$PWD:/config" -e UID="$(id -u)" -e GID="$(id -g)" -e BRANCH="$BRANCH" "$IMAGE"

# Rootless podman's uid mapping leaves the artifacts owned by a subuid;
# chown them back to the invoking user (container uid 0 == host user).
podman unshare chown 0:0 ./*.uf2 2>/dev/null || true
