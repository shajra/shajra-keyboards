{
  pkgsCross,
  shajra-keyboards-qmk,
}:

shajra-keyboards-qmk {
  buildKeyboardName = "ergodox_ez";
  targetNamePrefix = "ergodox_ez_base";
  firmwareExtension = "hex";
  keyboardId = "ergodoxez";
  keyboardDesc = "Ergodox EZ";
  nativeBuildInputs = [
    pkgsCross.avr.buildPackages.gcc
  ];
}
