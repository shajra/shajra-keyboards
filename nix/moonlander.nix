deps@
{ callPackage
, dfu-util
#, pkgsCross
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
    nativeBuildInputs = [
        dfu-util

	# DESIGN: maybe later can move to these as in the Nixpkgs derivation for
	# qmk_firmware, but for now these aren't cached in Hydra
        #
        #pkgsCross.avr.buildPackages.gcc
        #pkgsCross.avr.buildPackages.binutils
        #pkgsCross.arm-embedded.buildPackages.gcc
        #pkgsCross.armhf-embedded.buildPackages.gcc

        gcc-arm-embedded
    ];
    flashCmd = "${wally-cli}/bin/wally";
}
