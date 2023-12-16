{ pkgsCross
, shajra-keyboards-qmk
}:

shajra-keyboards-qmk {
    buildKeyboardName = "ergodox_ez";
    targetNameInfix = "_base";
    firmwareExtension = "hex";
    keyboardId = "ergodoxez";
    keyboardDesc = "Ergodox EZ";
    nativeBuildInputs = [
        pkgsCross.avr.buildPackages.gcc
    ];
}
