let

    fromGitHub = source: name:
        with source; pkgs-stable.fetchFromGitHub {
            inherit owner repo rev sha256 name;
            fetchSubmodules = true;
        };

    sources = import ./sources.nix;

    sources-json = builtins.fromJSON
        (builtins.readFile ./sources.json);

    nix-project-all = import sources.nix-project;

    arduino-tarball-avr = sources.arduino-tarball-avr;
    arduino-tarball-avrdude = sources.arduino-tarball-avrdude;
    arduino-tarball-avr-gcc = sources.arduino-tarball-avr-gcc;
    arduino-tarball-ctags = sources.arduino-tarball-ctags;
    arduino-tarball-ota = sources.arduino-tarball-ota;
    arduino-tarball-serial-discovery = sources.arduino-tarball-serial-discovery;
    hid-src = sources.pyhidapi;
    milc-src = sources.milc;
    qmk-cli-src = sources.qmk_cli;

    overlay = self: super: {
        nix-project-lib = nix-project-all.nix-project-lib;
        inherit
        arduino-tarball-avr
        arduino-tarball-avrdude
        arduino-tarball-avr-gcc
        arduino-tarball-ctags
        arduino-tarball-ota
        arduino-tarball-serial-discovery
        kaleidoscope-bundle
        hid-src
        milc-src
        qmk-cli-src
        qmk-factory
        shajra-keyboards-flash
        shajra-keyboards-lib;
    };

    pythonOverlay = self: super: {
        python3-unstable = pkgs-unstable.python3;
    };


    pkgs-stable = import sources.nixpkgs {
        config = {};
        overlays = [overlay pythonOverlay];
    };

    pkgs-unstable = import sources.nixpkgs-unstable {
        config = {};
        overlays = [overlay pythonOverlay];
    };

    qmk-factory = fromGitHub sources-json.qmk "qmk-src";

    kaleidoscope-bundle =
        fromGitHub sources-json.kaleidoscope-bundle "kaleidoscope-bundle-src";

    shajra-keyboards-lib = pkgs-stable.callPackage (import ./lib.nix) {};

    shajra-keyboards-flash =
        pkgs-stable.callPackage (import ./flash.nix) {};

in rec {

    # DESIGN: unstable has the latest Arduino binaries (good for Kaleidoscope)
    # DESIGN: unstable's GCC AVR and ARM compiler wasn't cached in Hydra (bad for QMK)
    shajra-keyboards-ergodoxez  = pkgs-stable.callPackage (import ./ergodoxez.nix)  {};
    shajra-keyboards-moonlander = pkgs-stable.callPackage (import ./moonlander.nix) {};
    shajra-keyboards-model01    = pkgs-unstable.callPackage (import ./model01.nix)  {};

    shajra-keyboards-flash-scripts =
        pkgs-stable.recurseIntoAttrs (
            pkgs-stable.callPackage (import ./flash-scripts.nix) {});

    shajra-keyboards-licenses =
        pkgs-stable.callPackage (import ./licenses.nix) {};

    inherit pkgs-unstable pkgs-stable shajra-keyboards-flash;

} // nix-project-all
