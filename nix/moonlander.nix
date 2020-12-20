deps@
{ callPackage
, dfu-util
, gcc-arm-embedded
, wally-cli
}:

{ factory ? false
, keymap  ? (import ./config.nix).default.keymap.moonlander
, keymaps ? ../keymaps/moonlander
}:

callPackage ./qmk.nix {} { inherit factory keymap keymaps; } {
    qmkKeyboardName = "moonlander";
    qmkTargetName = "moonlander";
    firmwareExtension = "bin";
    keyboardId = "moonlander";
    keyboardDesc = "Moonlander";
    buildInputs = [
        dfu-util
        gcc-arm-embedded
    ];
    flashCmd = "${wally-cli}/bin/wally-cli";
}
