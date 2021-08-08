{ callPackage
, pkgsCross
, teensy-loader-cli
, shajra-keyboards-config
}:

{ factory ? false
, keymap  ? shajra-keyboards-config.default.ergodoxez.keymap
, keymaps ? shajra-keyboards-config.default.ergodoxez.keymaps
}:

callPackage ./qmk.nix {} { inherit factory keymap keymaps; } {
    qmkKeyboardName = "ergodox_ez";
    qmkTargetName = "ergodox_ez";
    firmwareExtension = "hex";
    keyboardId = "ergodoxez";
    keyboardDesc = "Ergodox EZ";
    nativeBuildInputs = [
        pkgsCross.avr.buildPackages.gcc
    ];
    flashCmd =
        "\"${teensy-loader-cli}/bin/teensy-loader-cli\" -v -w --mcu=atmega32u4";
}
