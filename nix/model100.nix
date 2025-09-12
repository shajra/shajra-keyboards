{
  pkgsCross,
  shajra-keyboards-kaleidoscope,
}:

shajra-keyboards-kaleidoscope {
  buildKeyboardName = "Model100";
  fullyQualifiedBoardName = "keyboardio:gd32:keyboardio_model_100";
  keyboardId = "model100";
  keyboardDesc = "Keyboard.io Model 100";
  nativeBuildInputs = [
    pkgsCross.avr.buildPackages.gcc
  ];
}
