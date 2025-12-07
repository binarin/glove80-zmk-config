flash: build
    ./flash.sh

build:
    nix build '.#' -o result
