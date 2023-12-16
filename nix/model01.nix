{ pkgsCross
, shajra-keyboards-kaleidoscope
}:

shajra-keyboards-kaleidoscope {
    buildKeyboardName = "Model01";
    fullyQualifiedBoardName = "keyboardio:avr:model01";
    keyboardId = "model01";
    keyboardDesc = "Keyboard.io Model 01";
    nativeBuildInputs = [
        pkgsCross.avr.buildPackages.gcc
    ];
}
