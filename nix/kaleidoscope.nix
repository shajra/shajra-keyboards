{
  arduino-cli,
  arduino-boardsmanager-empty,
  arduino-cores-avr,
  arduino-tools-avr-gcc,
  arduino-tools-avrdude,
  arduino-tools-ctags,
  arduino-tools-dfu-util,
  arduino-tools-ota,
  arduino-discovery-dfu,
  arduino-discovery-mdns,
  arduino-discovery-serial,
  arduino-monitor-serial,
  arduino-xpack-arm,
  arduino-xpack-openocd,
  coreutils,
  gnugrep,
  keyboardio-arduinocore,
  keyboardio-boardsmanager,
  keyboardio-kaleidoscope-bundle,
  keyboardio-kaleidoscope-factory,
  perl,
  stdenv,
  shajra-keyboards-lib,
}:

{
  buildKeyboardName,
  fullyQualifiedBoardName,
  keyboardId,
  keyboardDesc,
  nativeBuildInputs,
}:

{
  factory,
  keymapsSource ? throw "must specify keymaps source if not factory",
  keymaps ? throw "must provide keymaps directory if not factory",
  keymap ? throw "must specify keymap if not factory",
}:

let

  lib = shajra-keyboards-lib;

  custom = lib.keymapPath keymaps keymap;

  scriptSuffix = if factory then "factory" else "${keymapsSource}-${keymap}";
  keymapDesc = if factory then "factory" else "${keymap} custom";

  kaleidoscope-custom = stdenv.mkDerivation {
    name = "kaleidoscope-${scriptSuffix}-src";
    src = keyboardio-kaleidoscope-factory;
    phases = [ "installPhase" ];
    installPhase = ''
      cp -r "$src" "$out"
      SKETCH_DIR="$out/examples/Devices/Keyboardio/${buildKeyboardName}"
      chmod -R +w "$SKETCH_DIR"
      rm "$SKETCH_DIR"/*.ino
      cp -Lr ${custom}/* "$SKETCH_DIR"
      chmod -R -w "$SKETCH_DIR"
    '';
  };

  kaleidoscope-src = if factory then keyboardio-kaleidoscope-factory else kaleidoscope-custom;

  lockNodes = (builtins.fromJSON (builtins.readFile ../flake.lock)).nodes;

  depName = name: baseNameOf lockNodes."${name}".original.url;

  setup = stdenv.mkDerivation {
    name = "kaleidoscope-setup";
    nativeBuildInputs = nativeBuildInputs ++ [
      arduino-cli
      perl
    ];
    src = keyboardio-kaleidoscope-factory;

    # DESIGN: To reproduce this work manually, I do the following:
    #
    #     1. Clone the Kaleidoscope repository
    #     2. VERBOSE=1 KALEIDOSCOPE_DIR=... make setup
    #
    #  That gives enough output of what's going on to mimic in the builder
    #  script below.  Dependencies might change. They are based upon some
    #  rather large JSON indices.  These can be upgraded with
    #  support/arduino-upgrade.
    #
    buildPhase = ''

      export KALEIDOSCOPE_DIR="$(pwd)"
      export KALEIDOSCOPE_TEMP_PATH="$(pwd)/tmp"
      export ARDUINO_BOARD_MANAGER_ADDITIONAL_URLS=https://raw.githubusercontent.com/keyboardio/boardsmanager/master/devel/package_kaleidoscope_devel_index.json
      export ARDUINO_CONTENT="$KALEIDOSCOPE_DIR/.arduino"
      export ARDUINO_DIRECTORIES_DATA="$ARDUINO_CONTENT/data"
      export ARDUINO_DIRECTORIES_DOWNLOADS="$ARDUINO_CONTENT/downloads"
      export ARDUINO_DIRECTORIES_USER="$ARDUINO_CONTENT/user"
      export ARDUINO_DATA_DIR="$ARDUINO_DIRECTORIES_DATA"  # maybe not needed
      export VERBOSE=1

      mkdir --parents "$ARDUINO_DIRECTORIES_DATA"
      mkdir --parents "$ARDUINO_DIRECTORIES_DOWNLOADS/packages"
      mkdir --parents "$ARDUINO_DIRECTORIES_USER/hardware"

      cp "${arduino/library_index.json}" \
          "$ARDUINO_DIRECTORIES_DATA/library_index.json"
      cp "${arduino/package_index.json}" \
          "$ARDUINO_DIRECTORIES_DATA/package_index.json"
      cp "${keyboardio-boardsmanager}" \
          "$ARDUINO_DIRECTORIES_DATA/package_kaleidoscope_devel_index.json"

      cp "${arduino-boardsmanager-empty}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-boardsmanager-empty"}"
      cp "${arduino-cores-avr}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-cores-avr"}"
      cp "${arduino-tools-avr-gcc}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-tools-avr-gcc"}"
      cp "${arduino-tools-avrdude}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-tools-avrdude"}"
      cp "${arduino-tools-ctags}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-tools-ctags"}"
      cp "${arduino-tools-dfu-util}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-tools-dfu-util"}"
      cp "${arduino-tools-ota}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-tools-ota"}"
      cp "${arduino-discovery-dfu}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-discovery-dfu"}"
      cp "${arduino-discovery-mdns}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-discovery-mdns"}"
      cp "${arduino-discovery-serial}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-discovery-serial"}"
      cp "${arduino-monitor-serial}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-monitor-serial"}"
      cp "${arduino-xpack-arm}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-xpack-arm"}"
      cp "${arduino-xpack-openocd}" \
          "$ARDUINO_DIRECTORIES_DOWNLOADS/packages/${depName "arduino-xpack-openocd"}"

      cp -r "${keyboardio-kaleidoscope-bundle}" \
          "$ARDUINO_DIRECTORIES_USER/hardware/keyboardio"
      chmod -R +w "$ARDUINO_DIRECTORIES_USER"
      cp -r "${keyboardio-arduinocore}" \
          "$ARDUINO_DIRECTORIES_USER/hardware/keyboardio/gd32"
      chmod -R +w "$ARDUINO_DIRECTORIES_USER"

      arduino-cli config init
      arduino-cli core install "arduino:avr"
      arduino-cli core install "keyboardio:avr-tools-only"
      arduino-cli core install "keyboardio:gd32-tools-only"

      make --directory "$ARDUINO_DIRECTORIES_USER/hardware/keyboardio" prepare-virtual
    '';

    installPhase = ''
      mkdir "$out"
      cp -r ".arduino/user" "$out"
      cp -r ".arduino/data" "$out"
    '';

  };

  hex = stdenv.mkDerivation {
    name = "${keyboardId}-${scriptSuffix}-hex";
    nativeBuildInputs = nativeBuildInputs ++ [ arduino-cli ];
    src = kaleidoscope-src;
    postPatch = ''
      BUILD_INFO="''${out#/nix/store/}"
      SKETCH_DIR="examples/Devices/Keyboardio/${buildKeyboardName}"
      echo "#define BUILD_INFORMATION \"$BUILD_INFO\"" > "$SKETCH_DIR/Version.h"
    '';
    buildPhase = ''

      export KALEIDOSCOPE_DIR="$(pwd)"
      export KALEIDOSCOPE_TEMP_PATH="$(pwd)/tmp"
      export ARDUINO_BOARD_MANAGER_ADDITIONAL_URLS=https://raw.githubusercontent.com/keyboardio/boardsmanager/master/devel/package_kaleidoscope_devel_index.json
      export ARDUINO_DIRECTORIES_DATA="${setup}/data"
      export ARDUINO_DIRECTORIES_USER="${setup}/user"
      export ARDUINO_DATA_DIR="$ARDUINO_DIRECTORIES_DATA"  # maybe not needed
      export FQBN="${fullyQualifiedBoardName}"
      export SKETCH_IDENTIFIER=${buildKeyboardName}
      export VERBOSE=1

      SKETCH_DIR="$KALEIDOSCOPE_DIR/examples/Devices/Keyboardio/${buildKeyboardName}"
      make --directory "$SKETCH_DIR"
    '';

    installPhase = ''
      cp -r "tmp/output/${buildKeyboardName}" "$out"
    '';

  };

  flash =
    lib.writeShellCheckedExe "${keyboardId}-${scriptSuffix}-flash"
      {
        meta.description = "Flash ${keyboardDesc} (${keymapDesc} keymap)";
        envKeep = [ "HOME" ];
        pathPackages = [
          arduino-cli
          coreutils
          gnugrep
        ];
      }
      ''
        set -eu
        set -o pipefail

        SOURCE="${kaleidoscope-src}"
        BINARY="${hex.out}"

        set +o pipefail
        PORT="$(env --ignore-environment \
            PATH="$PATH" \
            HOME="$HOME" \
            ARDUINO_DIRECTORIES_USER="${setup}/user" \
            arduino-cli board list \
            | grep ${fullyQualifiedBoardName} \
            | head -1 \
            | cut -d ' ' -f 1)"
        set -o pipefail

        echo
        echo FLASH SOURCE: "$SOURCE"
        echo FLASH BINARY: "$BINARY"

        if [ -z "$PORT" ]
        then
            echo
            echo "ERROR: no port detected (is your keyboard plugged in?)" >&2
            exit 1
        fi

        echo DETECTED PORT: "$PORT"
        echo
        SKETCH_DIR="$SOURCE/examples/Devices/Keyboardio/${buildKeyboardName}"
        cd "$SKETCH_DIR" || exit 1
        echo "To flash your keyboard, you must hold down the 'Prog' key."
        echo "While holding the 'Prog' key, press 'Enter', but continue to"
        echo "hold the 'Prog' key.  You can release it once flashing has"
        echo "started, and the key glows red."
        echo
        echo "Do these steps now, or Ctrl-C to quit..."
        read -r
        ARDUINO_DIRECTORIES_USER="${setup}/user" \
            ARDUINO_DIRECTORIES_DATA="${setup}/data" \
            arduino-cli \
            upload \
            --fqbn ${fullyQualifiedBoardName} \
            --input-dir "$BINARY" \
            --port "$PORT" \
            --verbose
      '';

in
{
  inherit flash hex;
}
