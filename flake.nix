{
  description = "Personal Keyboard Configuration via Nix";

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-project.url = "github:shajra/nix-project";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    keymaps-ergodoxez = {
      url = "github:shajra/empty";
      flake = false;
    };
    keymaps-model01 = {
      url = "github:shajra/empty";
      flake = false;
    };
    keymaps-model100 = {
      url = "github:shajra/empty";
      flake = false;
    };
    keymaps-moonlander = {
      url = "github:shajra/empty";
      flake = false;
    };
    arduino-lib-json = {
      url = "file+http://downloads.arduino.cc/libraries/library_index.json";
      flake = false;
    };
    arduino-pkgs-json = {
      url = "file+http://downloads.arduino.cc/packages/package_index.json";
      flake = false;
    };
    arduino-boardsmanager-empty = {
      url = "file+https://github.com/keyboardio/boardsmanager/raw/main/devel/empty.tbz";
      flake = false;
    };
    arduino-cores-avr = {
      url = "file+http://downloads.arduino.cc/cores/staging/avr-1.8.6.tar.bz2";
      flake = false;
    };
    arduino-tools-avr-gcc = {
      url = "file+http://downloads.arduino.cc/tools/avr-gcc-7.3.0-atmel3.6.1-arduino7-x86_64-pc-linux-gnu.tar.bz2";
      flake = false;
    };
    arduino-tools-avrdude = {
      url = "file+http://downloads.arduino.cc/tools/avrdude-6.3.0-arduino17-x86_64-pc-linux-gnu.tar.bz2";
      flake = false;
    };
    arduino-tools-ctags = {
      url = "file+https://downloads.arduino.cc/tools/ctags-5.8-arduino11-pm-x86_64-pc-linux-gnu.tar.bz2";
      flake = false;
    };
    arduino-tools-dfu-util = {
      url = "file+https://downloads.arduino.cc/tools/dfu-util-0.11.0-arduino3-linux64.tar.bz2";
      flake = false;
    };
    arduino-tools-ota = {
      url = "file+http://downloads.arduino.cc/tools/arduinoOTA-1.3.0-linux_amd64.tar.bz2";
      flake = false;
    };
    arduino-discovery-dfu = {
      url = "file+https://downloads.arduino.cc/discovery/dfu-discovery/dfu-discovery_v0.1.2_Linux_64bit.tar.gz";
      flake = false;
    };
    arduino-discovery-mdns = {
      url = "file+https://downloads.arduino.cc/discovery/mdns-discovery/mdns-discovery_v1.0.9_Linux_64bit.tar.gz";
      flake = false;
    };
    arduino-discovery-serial = {
      url = "file+https://downloads.arduino.cc/discovery/serial-discovery/serial-discovery_v1.4.1_Linux_64bit.tar.gz";
      flake = false;
    };
    arduino-monitor-serial = {
      url = "file+https://downloads.arduino.cc/monitor/serial-monitor/serial-monitor_v0.15.0_Linux_64bit.tar.gz";
      flake = false;
    };
    arduino-xpack-arm = {
      url = "file+https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/download/v9.3.1-1.3/xpack-arm-none-eabi-gcc-9.3.1-1.3-linux-x64.tar.gz";
      flake = false;
    };
    arduino-xpack-openocd = {
      url = "file+https://github.com/xpack-dev-tools/openocd-xpack/releases/download/v0.11.0-1/xpack-openocd-0.11.0-1-linux-x64.tar.gz";
      flake = false;
    };
    keyboardio-arduinocore = {
      url = "git+https://github.com/keyboardio/ArduinoCore-GD32-Keyboardio?submodules=1";
      flake = false;
    };
    keyboardio-boardsmanager = {
      url = "file+https://raw.githubusercontent.com/keyboardio/boardsmanager/master/devel/package_kaleidoscope_devel_index.json";
      flake = false;
    };
    keyboardio-kaleidoscope-bundle = {
      url = "git+https://github.com/keyboardio/Kaleidoscope-Bundle-Keyboardio?submodules=1";
      flake = false;
    };
    keyboardio-kaleidoscope-factory = {
      url = "git+https://github.com/keyboardio/Kaleidoscope";
      flake = false;
    };
    qmk-factory = {
      url = "git+https://github.com/qmk/qmk_firmware?submodules=1";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      let
        overlay = import nix/overlay.nix inputs withSystem;
      in
      {
        imports = [
          inputs.devshell.flakeModule
          inputs.nix-project.flakeModules.nixpkgs
          inputs.nix-project.flakeModules.org2gfm
          inputs.treefmt-nix.flakeModule
        ];
        systems = [ "x86_64-linux" ];
        perSystem =
          { config, nixpkgs, ... }:
          let
            build = nixpkgs.stable.extend overlay;
          in
          {
            _module.args.pkgs = nixpkgs.stable;
            packages = {
              default = build.shajra-keyboards-checks;
              flash-ergodoxez = build.shajra-keyboards-flash-scripts.ergodoxez;
              flash-model01 = build.shajra-keyboards-flash-scripts.model01;
              flash-model100 = build.shajra-keyboards-flash-scripts.model100;
              flash-moonlander = build.shajra-keyboards-flash-scripts.moonlander;
              licenses-thirdparty = build.shajra-keyboards-licenses;
            };
            apps = rec {
              default = licenses-thirdparty;
              licenses-thirdparty = {
                type = "app";
                program = "${build.shajra-keyboards-licenses}/bin/shajra-keyboards-licenses";
                inherit (build.shajra-keyboards-licenses) meta;
              };
              flash-ergodoxez = {
                type = "app";
                program = "${build.shajra-keyboards-flash-scripts.ergodoxez}/bin/flash-ergodoxez";
                inherit (build.shajra-keyboards-flash-scripts.ergodoxez)
                  meta
                  ;
              };
              flash-model01 = {
                type = "app";
                program = "${build.shajra-keyboards-flash-scripts.model01}/bin/flash-model01";
                inherit (build.shajra-keyboards-flash-scripts.model01)
                  meta
                  ;
              };
              flash-model100 = {
                type = "app";
                program = "${build.shajra-keyboards-flash-scripts.model100}/bin/flash-model100";
                inherit (build.shajra-keyboards-flash-scripts.model100)
                  meta
                  ;
              };
              flash-moonlander = {
                type = "app";
                program = "${build.shajra-keyboards-flash-scripts.moonlander}/bin/flash-moonlander";
                inherit (build.shajra-keyboards-flash-scripts.moonlander)
                  meta
                  ;
              };
            };
            checks.build = build.shajra-keyboards-checks;
            legacyPackages.nixpkgs = build;
            devshells.default = {
              commands = [
                {
                  name = "project-update";
                  help = "update project dependencies";
                  command = "nix flake update --commit-lock-file";
                }
                {
                  name = "project-check";
                  help = "run all checks/tests/linters";
                  command = "nix --print-build-logs flake check --show-trace";
                }
                {
                  name = "project-format";
                  help = "format all files in one command";
                  command = ''treefmt "$@"'';
                }
                {
                  name = "project-doc-gen";
                  help = "generate GitHub Markdown from Org files";
                  command = ''org2gfm "$@"'';
                }
                {
                  name = "project-arduino-upgrade";
                  help = "upgrade arduino JSON signatures";
                  command = "arduino-upgrade";
                }
                {
                  name = "project-kaleidoscope-deps";
                  help = "generate Kaleidoscope dependencies";
                  command = "kaleidoscope-deps";
                }
              ];
              packages = [
                config.treefmt.build.wrapper
                config.org2gfm.finalPackage
                build.shajra-keyboards-support-arduino-upgrade
                build.shajra-keyboards-support-kaleidoscope-deps
              ];
            };
            treefmt.pkgs = nixpkgs.unstable;
            treefmt.programs = {
              deadnix.enable = true;
              nixfmt.enable = true;
              nixf-diagnose.enable = true;
            };
            org2gfm = {
              settings = {
                envKeep = [
                  "HOME"
                  "LANG"
                  "LOCALE_ARCHIVE"
                ];
                pathKeep = [
                  "nix"
                ];
                pathPackages = [
                  nixpkgs.stable.ansifilter
                  nixpkgs.stable.bash
                  nixpkgs.stable.coreutils
                  nixpkgs.stable.git
                  nixpkgs.stable.gnugrep
                  nixpkgs.stable.gnutar
                  nixpkgs.stable.gzip
                  nixpkgs.stable.jq
                  nixpkgs.stable.nixfmt-rfc-style
                  nixpkgs.stable.tree
                ];
                pathExtras = [ "/bin" ];
                exclude = [ "internal" ];
                evaluate = true;
              };
            };
          };
        flake.overlays.default = overlay;
      }
    );
}
