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
        kaleidoscope-factory
        model01-factory
        qmk-factory
        shajra-keyboards-flash
        shajra-keyboards-lib;
    };

    pkgs-stable = import sources.nixpkgs {
        config = {};
        overlays = [overlay];
    };

    pkgs = import sources.nixpkgs-unstable {
        config = {};
        overlays = [overlay];
    };

    qmk-factory = fromGitHub sources-json.qmk "qmk-src";

    kaleidoscope-bundle =
        fromGitHub sources-json.kaleidoscope-bundle "kaleidoscope-bundle-src";

    kaleidoscope-factory = sources.kaleidoscope;

    model01-factory = sources.model01;

    shajra-keyboards-lib = pkgs.callPackage (import ./lib.nix) {};

    shajra-keyboards-flash =
        pkgs.callPackage (import ./flash.nix) {};

in rec {

    shajra-keyboards-ergodoxez  = pkgs.callPackage (import ./ergodoxez.nix)  {};
    shajra-keyboards-model01    = pkgs.callPackage (import ./model01.nix)    {};
    shajra-keyboards-moonlander = pkgs.callPackage (import ./moonlander.nix) {};

    shajra-keyboards-flash-scripts =
        pkgs.recurseIntoAttrs (
            pkgs.callPackage (import ./flash-scripts.nix) {});

    shajra-keyboards-licenses =
        pkgs.callPackage (import ./licenses.nix) {};

    inherit pkgs pkgs-stable shajra-keyboards-flash;

} // nix-project-all
