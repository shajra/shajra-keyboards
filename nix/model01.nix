{ arduino
, bashInteractive
, coreutils
, gawk
, gnugrep
, gnumake
, gnused
, perl
, stdenv
, systemd
, kaleidoscope-factory
, model01-factory
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

    kaleidoscope = stdenv.mkDerivation {
        name = "kaleidoscope-src";
        src = kaleidoscope-factory;
        buildPhase = ''
            true
        '';
        installPhase = ''
            BOARD_HARDWARE_PATH="$out/arduino/hardware"
            mkdir -p "$BOARD_HARDWARE_PATH"
            cp -rL . "$BOARD_HARDWARE_PATH/keyboardio"
        '';
    };

    model01 =
        let changeCmd =
            if ! factory
            then "cp -R ${custom}/. ."
            else "";
        in stdenv.mkDerivation {
            name = "model01-${scriptSuffix}-src";
            src = model01-factory;
            patchPhase = ''
                BUILD_INFO="$out"
                echo "#define BUILD_INFORMATION \"$BUILD_INFO\"" \
                    > src/Version.h
                ${changeCmd}
            '';
            buildPhase = ''
                true
            '';
            installPhase = ''
                cp -rL . "$out"
                cat $out/src/*
            '';
        };

    hex = stdenv.mkDerivation {
        name = "model01-${scriptSuffix}-hex";
        src = model01;
        buildPhase = ''
            mkdir "$out"
            SKETCHBOOK_DIR="${kaleidoscope}/arduino" \
                ARDUINO_PATH="${arduino}/share/arduino" \
                OUTPUT_PATH="$out" \
                make
        '';
        installPhase = ''
            true
        '';
    };

    # IDEA: Unfortunately, because Kaleidoscope has a more
    # complicated build/flash script, the flashing doesn't use
    # the "hex" derivation above yet.  The firmware is built
    # outside a Nix derivation when this flashing script is
    # called.  But Nix still helps to keep the environment of
    # that runtime build more hermetic.
    flash =
        let src = model01;
        in lib.writeShellChecked "model01-${scriptSuffix}-flash"
            "Flash Keyboard.io Model 01 (${keymapDesc} keymap)"
            ''
            PATH="${bashInteractive}/bin"
            PATH="${coreutils}/bin:$PATH"
            PATH="${gawk}/bin:$PATH"
            PATH="${gnugrep}/bin:$PATH"
            PATH="${gnumake}/bin:$PATH"
            PATH="${gnused}/bin:$PATH"
            PATH="${perl}/bin:$PATH"
            PATH="${systemd}/bin:$PATH"
            SOURCE="${src}"
            echo
            echo FLASH SOURCE: "$SOURCE"
            echo
            cd "$SOURCE" || exit 1
            env -i \
                PATH="$PATH" \
                SKETCHBOOK_DIR="${kaleidoscope}/arduino" \
                ARDUINO_PATH="${arduino}/share/arduino" \
                make flash
            '';

in { inherit flash hex; }
