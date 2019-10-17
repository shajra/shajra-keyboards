{ factory ? false
, keymap  ? (import ../config.nix).default.keymap.model01
}:

with (import ../common);

let

    custom = keymapPath ./keymaps keymap;

    scriptSuffix = if factory then "factory" else "custom-${keymap}";

    fetch = args: with args; pkgs.fetchFromGitHub {
        inherit owner repo sha256;
        rev = commit;
        fetchSubmodules = true;
    };

    kaleidoscope = pkgs.stdenv.mkDerivation {
        name = "kaleidoscope-src";
        src = fetch config.kaleidoscope;
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
        in pkgs.stdenv.mkDerivation {
            name = "model01-${scriptSuffix}-src";
            src = fetch config.model01;
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
                ls -la "$out"
                cat $out/src/*
            '';
        };

    hex = pkgs.stdenv.mkDerivation {
        name = "model01-${scriptSuffix}-hex";
        src = model01;
        buildPhase = ''
            mkdir "$out"
            SKETCHBOOK_DIR="${kaleidoscope}/arduino" \
                ARDUINO_PATH="${pkgs.arduino}/share/arduino" \
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
        in pkgs.writeShellScriptBin "model01-${scriptSuffix}-flash" ''
            PATH="${pkgs.coreutils}/bin"
            PATH="${pkgs.gawk}/bin:$PATH"
            PATH="${pkgs.gnugrep}/bin:$PATH"
            PATH="${pkgs.gnumake}/bin:$PATH"
            PATH="${pkgs.gnused}/bin:$PATH"
            PATH="${pkgs.perl}/bin:$PATH"
            PATH="${pkgs.systemd}/bin:$PATH"
            SOURCE="${src}"
            echo
            echo FLASH SOURCE: "$SOURCE"
            echo
            cd "$SOURCE"
            env -i \
                PATH="$PATH" \
                SKETCHBOOK_DIR="${kaleidoscope}/arduino" \
                ARDUINO_PATH="${pkgs.arduino}/share/arduino" \
                make flash
        '';

in { inherit flash hex; }
