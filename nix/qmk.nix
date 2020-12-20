{ python3
, qmk-factory
, stdenv
, shajra-keyboards-lib
}:

{ factory
, keymap
, keymaps
}:

{ qmkKeyboardName
, qmkTargetName
, firmwareExtension
, keyboardId
, keyboardDesc
, buildInputs
, flashCmd
}:

let

    lib = shajra-keyboards-lib;

    custom = lib.keymapPath keymaps keymap;

    scriptSuffix = if factory then "factory" else "custom-${keymap}";
    keymapDesc   = if factory then "factory" else "${keymap} custom";

    keymapName = if factory then "default" else keymap;

    qmk-custom = stdenv.mkDerivation {
        name = "qmk-${scriptSuffix}-src";
        src = qmk-factory;
        phases = ["installPhase"];
        installPhase = ''
            cp -r "$src" "$out"
            KEYMAPS_DIR="$out"/keyboards/${qmkKeyboardName}/keymaps
            chmod +w "$KEYMAPS_DIR"
            cp -r ${custom} "$KEYMAPS_DIR/${keymap}"
            chmod -w "$KEYMAPS_DIR"
        '';
    };

    qmk = if factory then qmk-factory else qmk-custom;

    hex = stdenv.mkDerivation {
        name = "${keyboardId}-${scriptSuffix}.${firmwareExtension}";
        nativeBuildInputs = [
            # DESIGN: the QMK build warns this will be needed in the future
            (python3.withPackages (ps: with ps; [
                appdirs
                argcomplete
                colorama
                hjson
                milc
                pygments
            ]))
        ];
        inherit buildInputs;
        src = qmk;
        postPatch = ''
            substituteInPlace bin/qmk \
                --replace "#!/usr/bin/env python" "#!$(command -v python)"
            VERSION="$out"
            echo "#define QMK_VERSION \"$VERSION\"" \
                > quantum/version.h
        '';
        buildPhase = ''
            SKIP_GIT=true SKIP_VERSION=true \
                make ${qmkTargetName}:${keymapName}
        '';
        installPhase = ''
            ls -l
            cp ${qmkTargetName}_${keymapName}.${firmwareExtension} "$out"
        '';
    };

    flash =
        let src = qmk;
            bin = hex;
        in lib.writeShellCheckedExe "${keyboardId}-${scriptSuffix}-flash" {
                meta.description =
                    "Flash ${keyboardDesc} (${keymapDesc} keymap)";
            }
            ''
            SOURCE="${src}"
            BINARY="${bin}"
            echo
            echo FLASH SOURCE: "$SOURCE"
            echo FLASH BINARY: "$BINARY"
            echo
            ${flashCmd} "$BINARY"
            '';

in { inherit flash hex; }
