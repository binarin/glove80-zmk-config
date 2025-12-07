{
  description = "Development environment for Glove80 ZMK keyboard configuration";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # XXX moergo-sc is not yet compatibl with 25.11
    nixpkgs-zmk.url = "github:NixOS/nixpkgs/nixos-25.05";
    zmk = {
      url = "github:moergo-sc/zmk";
      flake = false;
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devShells.default = pkgs.mkShell {
          name = "glove80-zmk-dev-shell";
          meta.description = "Development shell for editing Glove80 ZMK configuration";
          packages = with pkgs; [
            just
            udisks2
            figlet
          ];
        };

        packages.default = let
          pkgs-zmk = import inputs.nixpkgs-zmk { inherit system; };
          firmware = import "${inputs.zmk}/default.nix" { pkgs = pkgs-zmk; };
          config = ./config;
          glove80_left = firmware.zmk.override {
            board = "glove80_lh";
            keymap = "${config}/glove80.keymap";
            kconfig = "${config}/glove80.conf";
          };
          glove80_right = firmware.zmk.override {
            board = "glove80_rh";
            keymap = "${config}/glove80.keymap";
            kconfig = "${config}/glove80.conf";
          };
        in firmware.combine_uf2 glove80_left glove80_right;
      };
    };
}
