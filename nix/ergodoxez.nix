{ pkgsCross
, python3
, stdenv
, teensy-loader-cli
, qmk-factory
, shajra-keyboards-lib
}:

{ factory ? false
, keymap  ? (import ./config.nix).default.keymap.ergodoxez
, keymaps ? ../keymaps/ergodox_ez
}:

let

    lib = shajra-keyboards-lib;

    custom = lib.keymapPath keymaps keymap;

    scriptSuffix = if factory then "factory" else "custom-${keymap}";

    keymapName = if factory then "default" else keymap;

    qmk-custom = stdenv.mkDerivation {
        name = "qmk-${scriptSuffix}-src";
        src = qmk-factory;
        buildPhase = ''
            true
        '';
        installPhase = ''
            cp -r "$src" "$out"
            KEYMAPS_DIR="$out"/keyboards/ergodox_ez/keymaps
            chmod +w "$KEYMAPS_DIR"
            cp -r ${custom} "$KEYMAPS_DIR/${keymap}"
            chmod -w "$KEYMAPS_DIR"
        '';
    };

    qmk = if factory then qmk-factory else qmk-custom;

    hex = stdenv.mkDerivation {
        name = "ergodoxez-${scriptSuffix}-hex";
        nativeBuildInputs = [
	    # DESIGN: the QMK build warns this will be needed in the future
            python3
        ];
        buildInputs = [ pkgsCross.avr.buildPackages.gcc ];
        src = qmk;
        patchPhase = ''
            VERSION="$out"
            echo "#define QMK_VERSION \"$VERSION\"" \
                > quantum/version.h
        '';
        buildPhase = ''
            SKIP_GIT=true SKIP_VERSION=true \
                make ergodox_ez:${keymapName}
        '';
        installPhase = ''
            cp ergodox_ez_${keymapName}.hex "$out"
        '';
    };

    flash =
        let src = qmk;
            bin = hex;
        in lib.writeShellChecked "ergodoxez-${scriptSuffix}-flash" ''
             SOURCE="${src}"
             BINARY="${bin}"
             echo
             echo FLASH SOURCE: "$SOURCE"
             echo FLASH BINARY: "$BINARY"
             echo
             "${teensy-loader-cli}/bin/teensy-loader-cli" \
                -v -w --mcu=atmega32u4 \
                "$BINARY"
        '';

in { inherit flash hex; }
