{ externalOverrides ? {}
, externalJsonOverrides ? {}
}:

let

    fromGitHub = source: name:
        with source; pkgs-stable.fetchFromGitHub {
            inherit owner repo rev sha256 name;
            fetchSubmodules = true;
        };

    external = import external/sources.nix // externalOverrides;

    externalJson = builtins.fromJSON
        (builtins.readFile external/sources.json) // externalJsonOverrides;

    nix-project-all = import external.nix-project;

    arduino-tarball-avr = external.arduino-tarball-avr;
    arduino-tarball-avrdude = external.arduino-tarball-avrdude;
    arduino-tarball-avr-gcc = external.arduino-tarball-avr-gcc;
    arduino-tarball-ctags = external.arduino-tarball-ctags;
    arduino-tarball-ota = external.arduino-tarball-ota;
    arduino-tarball-serial-discovery = external.arduino-tarball-serial-discovery;
    qmk-cli-src = external.qmk_cli;
    qmk-dotty-dict-src = external.qmk-dotty-dict;

    overlay = self: super: {
        nix-project-lib = nix-project-all.nix-project-lib;
        shajra-keyboards-config = import ../config.nix;
        inherit
        arduino-tarball-avr
        arduino-tarball-avrdude
        arduino-tarball-avr-gcc
        arduino-tarball-ctags
        arduino-tarball-ota
        arduino-tarball-serial-discovery
        kaleidoscope-bundle
        qmk-cli-src
        qmk-dotty-dict-src
        qmk-factory
        shajra-keyboards-flash
        shajra-keyboards-lib;
    };

    pythonOverlay = self: super: {
        python3-unstable = pkgs-unstable.python3;
    };


    pkgs-stable = import external.nixpkgs {
        config = {};
        overlays = [overlay pythonOverlay];
    };

    pkgs-unstable = import external.nixpkgs-unstable {
        config = {};
        overlays = [overlay pythonOverlay];
    };

    qmk-factory = fromGitHub externalJson.qmk "qmk-src";
    kaleidoscope-bundle =
        fromGitHub externalJson.kaleidoscope-bundle "kaleidoscope-bundle-src";

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
