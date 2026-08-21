{ pkgs ? import <nixpkgs> {}
, firmware ? import ../src {}
}:

let
  # Keep the physical layout: <name>/<name>.keymap next to shared/, so
  # keymaps can `#include "../shared/common.dtsi"`.
  mkKeymapDir = name: dir: pkgs.runCommandNoCC "${name}-config" {} ''
    mkdir -p $out/${name} $out/shared
    cp -r ${dir}/. $out/${name}/
    cp -r ${./shared}/. $out/shared/
  '';

  mkKeyboard = { left, right, name }: let
    keymapDir = mkKeymapDir name (./. + "/${name}");
  in firmware.combine_uf2
    (firmware.zmk.override {
      board = left;
      keymap = "${keymapDir}/${name}/${name}.keymap";
      kconfig = "${keymapDir}/${name}/${name}.conf";
    })
    (firmware.zmk.override {
      board = right;
      keymap = "${keymapDir}/${name}/${name}.keymap";
      kconfig = "${keymapDir}/${name}/${name}.conf";
    })
    name;

in {
  glove80 = mkKeyboard { left = "glove80_lh"; right = "glove80_rh"; name = "glove80"; };
  go60    = mkKeyboard { left = "go60_lh";   right = "go60_rh";   name = "go60"; };
}
