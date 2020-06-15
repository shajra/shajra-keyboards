{ coreutils
, kaleidoscope-factory
, model01-factory
, qmk-factory
, shajra-keyboards-lib
}:


shajra-keyboards-lib.writeShellChecked "shajra-keyboards-licenses"
"License information for shajra-keyboards project"
''
set -eu

${coreutils}/bin/cat - <<EOF
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

    ${qmk-factory}

Kaleidoscope firmware source for Keyboardio keyboards (GPLv3):

    ${kaleidoscope-factory}

Model 01 firmware specification for Model 01 (GPLv3):

    ${model01-factory}

EOF
''
