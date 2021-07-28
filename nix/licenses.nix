{ coreutils
, kaleidoscope-bundle
, qmk-factory
, shajra-keyboards-lib
}:


shajra-keyboards-lib.writeShellCheckedExe "shajra-keyboards-licenses"
{
    meta.description =
        "License information for shajra-keyboards project";
}
''
set -eu
set -o pipefail

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

QMK firmware source for Ergodox EZ and Moonlander (GPLv2, mostly):

    ${qmk-factory}

Kaleidoscope firmware source for Keyboardio keyboards (GPLv3):

    ${kaleidoscope-bundle}

EOF
''
