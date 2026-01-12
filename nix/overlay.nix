inputs: withSystem: final: prev:

let

  config = import ../config.nix;
  inherit (prev.stdenv.hostPlatform) system;

in
withSystem system (
  { inputs', ... }:
  {

    inherit (inputs)
      arduino-lib-json
      arduino-pkgs-json
      arduino-boardsmanager-empty
      arduino-cores-avr
      arduino-tools-avr-gcc
      arduino-tools-avrdude
      arduino-tools-ctags
      arduino-tools-dfu-util
      arduino-tools-ota
      arduino-discovery-dfu
      arduino-discovery-mdns
      arduino-discovery-serial
      arduino-monitor-serial
      arduino-xpack-arm
      arduino-xpack-openocd
      keyboardio-arduinocore
      keyboardio-boardsmanager
      keyboardio-kaleidoscope-bundle
      keyboardio-kaleidoscope-factory
      qmk-factory
      ;

    nix-project-lib = inputs'.nix-project.legacyPackages.lib.scripts;
    inherit (inputs'.nix-project.packages) org2gfm;

    shajra-keyboards-keymaps = {
      builtin = {
        ergodoxez = config.ergodoxez.keymaps;
        model01 = config.model01.keymaps;
        model100 = config.model100.keymaps;
        moonlander = config.moonlander.keymaps;
      };
      input = {
        ergodoxez = inputs.keymaps-ergodoxez;
        model01 = inputs.keymaps-model01;
        model100 = inputs.keymaps-model100;
        moonlander = inputs.keymaps-moonlander;
      };
    };

    shajra-keyboards-keymap = {
      ergodoxez = config.ergodoxez.keymap;
      model01 = config.model01.keymap;
      model100 = config.model100.keymap;
      moonlander = config.moonlander.keymap;
    };

    shajra-keyboards-lib = final.callPackage ./lib.nix { };
    shajra-keyboards-qmk = final.callPackage ./qmk.nix { };
    shajra-keyboards-kaleidoscope = final.callPackage ./kaleidoscope.nix { };
    shajra-keyboards-flash = final.callPackage ./flash.nix { };

    shajra-keyboards-builder = {
      ergodoxez = final.callPackage ./ergodoxez.nix { };
      model01 = final.callPackage ./model01.nix { };
      model100 = final.callPackage ./model100.nix { };
      moonlander = final.callPackage ./moonlander.nix { };
    };

    shajra-keyboards-build = final.lib.recurseIntoAttrs (final.callPackage ./build.nix { });

    shajra-keyboards-flash-scripts = final.lib.recurseIntoAttrs (
      final.callPackage ./flash-scripts.nix { }
    );

    shajra-keyboards-licenses = final.callPackage ./licenses.nix { };

    shajra-keyboards-support-arduino-upgrade = final.callPackage ./support/arduino-upgrade.nix { };
    shajra-keyboards-support-kaleidoscope-deps = final.callPackage ./support/kaleidoscope-deps.nix { };

    shajra-keyboards-build-all = final.callPackage ./build-all.nix { };

    shajra-keyboards-checks = final.callPackage ./checks.nix { };
  }
)
