{ python3-unstable
, poetry2nix
, which
, hidapi
, qmk-cli-src
, hid-src
, milc-src
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
        dotty-dict = super.dotty-dict.overridePythonAttrs(old: {
            propagatedBuildInputs = [super.setuptools-scm];
        });
        qmk-cli = super.buildPythonApplication {
            pname = "qmk";
            version = "0.0.0";
            src = qmk-cli-src;
            propagatedBuildInputs = with self; [
                dotty-dict
                hid
                hjson
                jsonschema
                milc
                pyusb
                pygments
            ];
            buildInputs = with self; [
                flake8
                nose2
                yapf
            ];
            doCheck = false;
        };
        hid = super.buildPythonPackage {
            pname = "hid";
            version = "0.0.0";
            src = hid-src;
            doCheck = false;
            buildInputs = with self; [
                hidapi
            ];
            postPatch = ''
                substituteInPlace hid/__init__.py \
                    --replace "libhidapi" "${hidapi}/lib/libhidapi"
            '';
        };
        milc = super.buildPythonPackage {
            pname = "milc";
            version = "0.0.0";
            src = milc-src;
            propagatedBuildInputs = with self; [
                appdirs
                argcomplete
                colorama
                halo
                spinners
            ];
            checkInputs = with self; [
                flake8
                hjson
                nose2
                semver
                yapf
            ];
        };
    };

    qmk-cli = (python3-unstable.override {
        packageOverrides = pythonOverrides;
    }).pkgs.qmk-cli;

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
