{ gcc-arm-embedded
, shajra-keyboards-qmk
}:

shajra-keyboards-qmk {
    buildKeyboardName = "moonlander";
    targetNameInfix = "";
    firmwareExtension = "bin";
    keyboardId = "moonlander";
    keyboardDesc = "Moonlander";
    nativeBuildInputs = [
        # DESIGN: not exactly sure why we don't use the following:
        #pkgsCross.arm-embedded.buildPackages.gcc
        gcc-arm-embedded
    ];
}
