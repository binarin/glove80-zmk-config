#!/usr/bin/env bash
set -euo pipefail
: "${BRANCH:=main}"

echo "Checking out $BRANCH from moergo-sc/zmk" >&2
cd /src
git fetch origin
git checkout -q --detach "$BRANCH"

cd /config
for keyboard in glove80 go60; do
    echo "Building $keyboard firmware" >&2
    nix-build ./config --arg firmware 'import /src/default.nix {}' --arg pkgs 'import /src/nix/pinned-nixpkgs.nix {}' -A "$keyboard" -j2 -o "/tmp/$keyboard" --show-trace
    install -o "$UID" -g "$GID" "/tmp/$keyboard/$keyboard.uf2" "./$keyboard.uf2"
done
