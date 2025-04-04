{
    description = "Personal Keyboard Configuration via Nix";

    inputs = {
        flake-parts.url = "github:hercules-ci/flake-parts";
        nix-project.url = "github:shajra/nix-project";
        keymaps-ergodoxez  = { url = "github:shajra/empty"; flake = false; };
        keymaps-model01    = { url = "github:shajra/empty"; flake = false; };
        keymaps-model100   = { url = "github:shajra/empty"; flake = false; };
        keymaps-moonlander = { url = "github:shajra/empty"; flake = false; };
        arduino-lib-json = {
            url = "file+http://downloads.arduino.cc/libraries/library_index.json";
            flake = false;
        };
        arduino-lib-sig = {
            url = "file+http://downloads.arduino.cc/libraries/library_index.json.sig";
            flake = false;
        };
        arduino-pkgs-json = {
            url = "file+http://downloads.arduino.cc/packages/package_index.json";
            flake = false;
        };
        arduino-pkgs-sig = {
            url = "file+http://downloads.arduino.cc/packages/package_index.json.sig";
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
          url =
          "file+https://raw.githubusercontent.com/keyboardio/boardsmanager/master/devel/package_kaleidoscope_devel_index.json";
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

    outputs = inputs@{ flake-parts, nix-project, ... }:
        flake-parts.lib.mkFlake { inherit inputs; } ({withSystem, config, ... }: {
            imports = [ nix-project.flakeModules.nixpkgs ];
            systems = [ "x86_64-linux" ];
            perSystem = { system, nixpkgs, ... }:
                let build = import nixpkgs.stable.path {
                        inherit system;
                        overlays = [ config.flake.overlays.default ];
                    };
                in {
                    packages = {
                        default             = build.shajra-keyboards-ci;
                        flash-ergodoxez     = build.shajra-keyboards-flash-scripts.ergodoxez;
                        flash-model01       = build.shajra-keyboards-flash-scripts.model01;
                        flash-model100      = build.shajra-keyboards-flash-scripts.model100;
                        flash-moonlander    = build.shajra-keyboards-flash-scripts.moonlander;
                        licenses-thirdparty = build.shajra-keyboards-licenses;
                    };
                    checks.ci = build.shajra-keyboards-ci;
                    legacyPackages.nixpkgs = build;
                    apps = rec {
                        default = licenses-thirdparty;
                        licenses-thirdparty = {
                            type = "app";
                            program =
                                "${build.shajra-keyboards-licenses}/bin/shajra-keyboards-licenses";
                        };
                        flash-ergodoxez = {
                            type = "app";
                            program =
                                "${build.shajra-keyboards-flash-scripts.ergodoxez}/bin/flash-ergodoxez";
                        };
                        flash-model01 = {
                            type = "app";
                            program =
                                "${build.shajra-keyboards-flash-scripts.model01}/bin/flash-model01";
                        };
                        flash-model100 = {
                            type = "app";
                            program =
                                "${build.shajra-keyboards-flash-scripts.model100}/bin/flash-model100";
                        };
                        flash-moonlander = {
                            type = "app";
                            program =
                                "${build.shajra-keyboards-flash-scripts.moonlander}/bin/flash-moonlander";
                        };
                    };
                };
            flake.overlays.default =
                import nix/overlay.nix inputs withSystem;
        });
}
