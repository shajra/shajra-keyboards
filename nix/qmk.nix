{ pyrsistent-src
, python3-unstable
, pyusb-src
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
        pyusb = super.pyusb.overridePythonAttrs (old: {
            version = "1.2.1";
            src = pyusb-src;
        });
        pyrsistent = super.pyrsistent.overridePythonAttrs (old: {
            version = "0.18.0";
            src = pyrsistent-src;
        });
        qmk_cli = super.buildPythonApplication {
            pname = "qmk_cli";
            # DESIGN: updating to a newer CLI is annoying because they
            # started exact-pinning dependencies
            version = "0.0.52";
            src = qmk-cli-src;
            propagatedBuildInputs = with self; [
                appdirs
                argcomplete
                attrs
                colorama
                coverage
                qmk-dotty-dict
                halo
                hid
                hjson
                jsonschema
                log-symbols
                mccabe
                milc
                pycodestyle
                pyflakes
                pygments
                pyrsistent
                pyusb
                six
                spinners
                termcolor
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
