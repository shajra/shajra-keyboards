{ gnugrep
, qmk
, qmk-factory
, stdenv
, wally-cli
, shajra-keyboards-lib
}:

{ buildKeyboardName
, targetNameInfix
, firmwareExtension
, keyboardId
, keyboardDesc
, nativeBuildInputs
}:

{ factory
, keymapsSource ? throw "must specify keymaps source if not factory"
, keymaps ? throw "must provide keymaps directory if not factory"
, keymap ? throw "must specify keymap if not factory"
}:

let

    lib = shajra-keyboards-lib;

    custom = lib.keymapPath keymaps keymap;

    scriptSuffix = if factory then "factory" else "${keymapsSource}-${keymap}";
    keymapDesc   = if factory then "factory" else "${keymap} custom";

    keymapName = if factory then "default" else keymap;

    qmk-custom = stdenv.mkDerivation {
        name = "qmk-${scriptSuffix}-src";
        src = qmk-factory;
        phases = ["installPhase"];
        installPhase = ''
            cp -r "$src" "$out"
            KEYMAPS_DIR="$out"/keyboards/${buildKeyboardName}/keymaps
            chmod -R +w "$KEYMAPS_DIR"
            rm -rf "$KEYMAPS_DIR/${keymap}"
            cp -r ${custom} "$KEYMAPS_DIR/${keymap}"
            chmod -R -w "$KEYMAPS_DIR"
        '';
    };

    qmk-src = if factory then qmk-factory else qmk-custom;

    hex = stdenv.mkDerivation {
        name = "${keyboardId}-${scriptSuffix}.${firmwareExtension}";
        nativeBuildInputs = nativeBuildInputs ++ [ qmk ];
        src = qmk-src;
        postPatch = ''
            VERSION="''${out#/nix/store}"
            echo "#define QMK_VERSION \"$VERSION\"" \
                > quantum/version.h
        '';
        buildPhase = ''
            SKIP_GIT=true SKIP_VERSION=true \
                make ${buildKeyboardName}:${keymapName}
        '';
        installPhase = ''
            cp ${buildKeyboardName}${targetNameInfix}_${keymapName}.${firmwareExtension} "$out"
        '';
    };

    flash = lib.writeShellCheckedExe "${keyboardId}-${scriptSuffix}-flash" {
            meta.description =
                "Flash ${keyboardDesc} (${keymapDesc} keymap)";
            path = [ gnugrep ];
        }
        ''
        set -eu
        set -o pipefail
        SOURCE="${qmk-src}"
        BINARY="${hex}"
        echo
        echo FLASH SOURCE: "$SOURCE"
        echo FLASH BINARY: "$BINARY"
        echo
        # DESIGN: https://github.com/google/gousb/issues/87
        exec "${wally-cli}/bin/wally-cli" "$BINARY" 2> >(grep -v '[code -10]' >&2)
    '';

in { inherit flash hex; }
