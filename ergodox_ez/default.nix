{ factory ? false
, keymap  ? (import ../config.nix).default.keymap.ergodoxez
}:

with (import ../common);

let

    custom = keymapPath ./keymaps keymap;

    keymapName = if factory then "default" else keymap;
    scriptSuffix = if factory then "factory" else "custom-${keymap}";

    qmk-factory = with config.qmk; pkgs.fetchFromGitHub {
        inherit owner repo sha256;
        rev = commit;
        fetchSubmodules = true;
        name = "qmk-${scriptSuffix}-src";
    };

    qmk-custom = pkgs.stdenv.mkDerivation {
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

    hex =
        let env = import "${qmk-factory}/shell.nix" { inherit pkgs; };
        in pkgs.stdenv.mkDerivation {
            name = "ergodoxez-${scriptSuffix}-hex";
            buildInputs = env.buildInputs;
            CFLAGS = env.CFLAGS;
            ASFLAGS = env.ASFLAGS;
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
        in pkgs.writeShellScriptBin "ergodoxez-${scriptSuffix}-flash" ''
             SOURCE="${src}"
             BINARY="${bin}"
             echo
             echo FLASH SOURCE: "$SOURCE"
             echo FLASH BINARY: "$BINARY"
             echo
             "${pkgs.teensy-loader-cli}/bin/teensy-loader-cli" \
                -v -w --mcu=atmega32u4 \
                "$BINARY"
        '';

in { inherit flash hex; }
