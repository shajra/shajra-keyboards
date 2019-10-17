with (import ./.);

pkgs.writeShellScriptBin "shajra-keyboards-licenses"
''
set -eu

${pkgs.coreutils}/bin/cat - <<EOF
Third Party Licenses for "shajra-keyboards"
===========================================

This project is a build script that uses Nix to download third
party source codes, modify them as per their respective
instructions, and then compile binaries for flashing keyboards.

As such, this work is not directly a derivative work as much as a
script for making derivative work.

The following are links to the exact source downloaded and used,
including all license information (most of which is GPLv3 or
GPLv2):

QMK firmware source for Ergodox EZ (GPLv2, mostly):

    ${thirdParty.qmk}

Kaleidoscope firmware source for Keyboardio keyboards (GPLv3):

    ${thirdParty.kaleidoscope}

Model 01 firmware specification for Model 01 (GPLv3):

    ${thirdParty.model01}

EOF
''
