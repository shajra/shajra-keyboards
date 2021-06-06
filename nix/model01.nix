{ arduino-cli
, arduino-tarball-avr
, arduino-tarball-avrdude
, arduino-tarball-avr-gcc
, arduino-tarball-ctags
, arduino-tarball-ota
, arduino-tarball-serial-discovery
, coreutils
, gnugrep
, perl
, pkgs
, stdenv
, kaleidoscope-bundle
, shajra-keyboards-lib
}:

{ factory ? false
, keymap  ? (import ./config.nix).default.keymap.model01
, keymaps ? ../keymaps/model_01
}:

let

    lib = shajra-keyboards-lib;

    custom = lib.keymapPath keymaps keymap;

    scriptSuffix = if factory then "factory" else "custom-${keymap}";
    keymapDesc   = if factory then "factory" else "${keymap} custom";

    model01 =
        let changeCmd =
            if ! factory
            then "cp -R ${custom}/. ."
            else "";
        in stdenv.mkDerivation {
            name = "model01-${scriptSuffix}-src";
            src = "${kaleidoscope-bundle}/avr/libraries/Model01-Firmware";
            phases = ["unpackPhase" "patchPhase" "installPhase"];
            patchPhase = ''
                BUILD_INFO="''${out#/nix/store/}"
                echo "#define BUILD_INFORMATION \"$BUILD_INFO\"" \
                    > src/Version.h
                ${changeCmd}
            '';
            installPhase = ''
                mkdir "$out"
                cp -rL . "$out/Model01-Firmware"
            '';
        };

    # DESIGN: Arduino-cli errantly names files "tar.bz2" irrespective of what
    # the compression really is.
    depName = p:
        let bn = builtins.baseNameOf p.url;
        in builtins.replaceStrings ["tar.gz"] ["tar.bz2"] bn;

    hex = stdenv.mkDerivation {
        name = "model01-${scriptSuffix}-hex";
        src = model01;
        outputs = ["out" "arduino"];
        sourceRoot = ".";
        nativeBuildInputs = [arduino-cli perl];
        phases = ["unpackPhase" "buildPhase"];
        buildPhase = ''
            export KALEIDOSCOPE_TEMP_PATH="$out"
            export ARDUINO_CONTENT="$arduino"
            export ARDUINO_DIRECTORIES_USER="$arduino/user"
            export ARDUINO_DIRECTORIES_DATA="$arduino/data"
            export ARDUINO_DIRECTORIES_DOWNLOADS="$arduino/data/staging"
            export SKETCH_IDENTIFIER=Model01-Firmware
            export VERBOSE=1

            mkdir --parents "$KALEIDOSCOPE_TEMP_PATH"
            mkdir --parents "$ARDUINO_DIRECTORIES_USER/hardware"
            mkdir --parents "$ARDUINO_DIRECTORIES_DATA/staging/packages"
            mkdir --parents "$ARDUINO_DIRECTORIES_DATA/staging/tools"

            cp --archive ${kaleidoscope-bundle} \
                "$arduino/user/hardware/keyboardio"
            chmod -R +w "$arduino/user/hardware/keyboardio"

            cp "${./arduino/library_index.json}" \
                "$arduino/data/library_index.json"
            cp "${./arduino/package_index.json}" \
                "$arduino/data/package_index.json"
            cp "${./arduino/package_index.json.sig}" \
                "$arduino/data/package_index.json.sig"
            cp "${./arduino/package_keyboardio_index.json}" \
                "$arduino/data/package_keyboardio_index.json"
            ln --symbolic "${arduino-tarball-avr}" \
                "$arduino/data/staging/packages/${depName arduino-tarball-avr}"
            ln --symbolic "${arduino-tarball-avrdude}" \
                "$arduino/data/staging/packages/${depName arduino-tarball-avrdude}"
            ln --symbolic "${arduino-tarball-avr-gcc}" \
                "$arduino/data/staging/packages/${depName arduino-tarball-avr-gcc}"
            ln --symbolic "${arduino-tarball-ota}" \
                "$arduino/data/staging/packages/${depName arduino-tarball-ota}"
            ln --symbolic "${arduino-tarball-ctags}" \
                "$arduino/data/staging/tools/${depName arduino-tarball-ctags}"
            ln --symbolic "${arduino-tarball-serial-discovery}" \
                "$arduino/data/staging/tools/${depName arduino-tarball-serial-discovery}"

            make --directory "$ARDUINO_DIRECTORIES_USER/hardware/keyboardio" \
                 prepare-virtual

            arduino-cli config init
            arduino-cli core install "arduino:avr"

            cd "model01-${scriptSuffix}-src/Model01-Firmware"
            make compile
        '';

    };

    flash =
        let src = model01;
            bin = hex.out;
        in lib.writeShellCheckedExe "model01-${scriptSuffix}-flash" {
                meta.description =
                    "Flash Keyboard.io Model 01 (${keymapDesc} keymap)";
            }
            ''
            PATH="${arduino-cli}/bin"
            PATH="${coreutils}/bin:$PATH"
            PATH="${gnugrep}/bin:$PATH"
            SOURCE="${src}"
            BINARY="${bin}"

            PORT="$(env -i \
                PATH="$PATH" \
                HOME="$HOME" \
                ARDUINO_DIRECTORIES_USER="${hex.arduino}/user" \
                arduino-cli board list \
                | grep keyboardio:avr \
                | head -1 \
                | cut -d ' ' -f 1)"

            echo
            echo FLASH SOURCE: "$SOURCE"
            echo FLASH BINARY: "$BINARY"

            if [ -z "$PORT" ]
            then
                echo
                echo "ERROR: no port detected (is your Model 01 keyboard plugged in?)" >&2
                exit 1
            fi

            echo DETECTED PORT: "$PORT"
            echo
            cd "$SOURCE/Model01-Firmware" || exit 1
            echo "To flash your keyboard, you must hold down the 'Prog' key."
            echo "While holding the 'Prog' key, press 'Enter', but continue to"
            echo "hold the 'Prog' key.  You can release it once flashing has"
            echo "started, and the key glows red."
            echo
            echo "Do these steps now, or Ctrl-C to quit..."
            read -r
            "${coreutils}/bin/env" -i \
                PATH="$PATH" \
                HOME="$HOME" \
                ARDUINO_DIRECTORIES_USER="${hex.arduino}/user" \
                ARDUINO_DIRECTORIES_DATA="${hex.arduino}/data" \
                arduino-cli \
                upload \
                --fqbn keyboardio:avr:model01 \
                --input-dir "${bin}/output/Model01-Firmware" \
                --port "$PORT" \
                --verbose
            '';

in { inherit flash hex; }
