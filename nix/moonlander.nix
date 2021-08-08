deps@
{ callPackage
, dfu-util
, gcc-arm-embedded
#, pkgsCross
, wally-cli
, shajra-keyboards-config
}:

{ factory ? false
, keymap ? shajra-keyboards-config.default.moonlander.keymap
, keymaps ? shajra-keyboards-config.default.moonlander.keymaps
}:

callPackage ./qmk.nix {} { inherit factory keymap keymaps; } {
    qmkKeyboardName = "moonlander";
    qmkTargetName = "moonlander";
    firmwareExtension = "bin";
    keyboardId = "moonlander";
    keyboardDesc = "Moonlander";
    nativeBuildInputs = [
        dfu-util

        # DESIGN: maybe later can move to these as in the Nixpkgs derivation for
        # qmk_firmware, but for now there's a problem with the ARM cross build
        # not supporting newlib-nano.
        #
        #pkgsCross.arm-embedded.buildPackages.gcc

        gcc-arm-embedded
    ];
    flashCmd = "\"${wally-cli}/bin/wally-cli\"";
}
