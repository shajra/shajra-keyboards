{ callPackage
, pkgsCross
, teensy-loader-cli
}:

{ factory ? false
, keymap  ? (import ./config.nix).default.keymap.ergodoxez
, keymaps ? ../keymaps/ergodox_ez
}:

callPackage ./qmk.nix {} { inherit factory keymap keymaps; } {
    qmkKeyboardName = "ergodox_ez";
    qmkTargetName = "ergodox_ez";
    firmwareExtension = "hex";
    keyboardId = "ergodoxez";
    keyboardDesc = "Ergodox EZ";
    buildInputs = [
        pkgsCross.avr.buildPackages.gcc
    ];
    flashCmd =
        "${teensy-loader-cli}/bin/teensy-loader-cli -v -w --mcu=atmega32u4";
}
