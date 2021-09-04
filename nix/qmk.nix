{ gnugrep
, python3-unstable
, qmk-cli-src
, qmk-dotty-dict-src
, qmk-factory
, stdenv
, which
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
, nativeBuildInputs
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

    qmk-src = if factory then qmk-factory else qmk-custom;

    pythonOverrides = self: super: {
        qmk-dotty-dict = super.dotty-dict.overridePythonAttrs(old: {
            pname = "qmk-dotty-dict";
            version = "1.3.0.post1";
            src = qmk-dotty-dict-src;
        });
        qmk_cli = super.buildPythonApplication {
            pname = "qmk_cli";
            version = "1.0.0";
            src = qmk-cli-src;
            patchPhase = ''
                cat << EOF > setup.py
                from setuptools import setup

                if __name__ == "__main__":
                    setup()
                EOF
            '';
            propagatedBuildInputs = with self; [
                hid
                milc
                pyusb
                hjson
                jsonschema
                pygments
                qmk-dotty-dict
            ];
            buildInputs = with self; [
                flake8
                nose2
                yapf
            ];
            doCheck = false;
        };
    };

    qmk-cli = (python3-unstable.override {
        packageOverrides = pythonOverrides;
    }).pkgs.qmk_cli;

    hex = stdenv.mkDerivation {
        name = "${keyboardId}-${scriptSuffix}.${firmwareExtension}";
        nativeBuildInputs = nativeBuildInputs ++ [
            which
            qmk-cli
        ];
        src = qmk-src;
        postPatch = ''
            VERSION="$out"
            echo "#define QMK_VERSION \"$VERSION\"" \
                > quantum/version.h
        '';
        buildPhase = ''
            qmk
            SKIP_GIT=true SKIP_VERSION=true \
                make ${qmkTargetName}:${keymapName}
        '';
        installPhase = ''
            cp ${qmkTargetName}_${keymapName}.${firmwareExtension} "$out"
        '';
    };

    flash =
        let src = qmk-src;
            bin = hex;
        in lib.writeShellCheckedExe "${keyboardId}-${scriptSuffix}-flash" {
                meta.description =
                    "Flash ${keyboardDesc} (${keymapDesc} keymap)";
                path = [ gnugrep ];
            }
            ''
            set -eu
            set -o pipefail
            SOURCE="${src}"
            BINARY="${bin}"
            echo
            echo FLASH SOURCE: "$SOURCE"
            echo FLASH BINARY: "$BINARY"
            echo
            # DESIGN: https://github.com/google/gousb/issues/87
            exec ${flashCmd} "$BINARY" 2> >(grep -v '[code -10]' >&2)
            '';

in { inherit flash hex; }
