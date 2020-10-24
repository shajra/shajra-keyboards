let

    fromGitHub = source: name:
        with source; pkgs.fetchFromGitHub {
            inherit owner repo rev sha256 name;
            fetchSubmodules = true;
        };

    sources = builtins.fromJSON
        (builtins.readFile ./sources.json);

    nix-project-all = import (import ./sources.nix).nix-project;

    overlay = self: super: {
        nix-project-lib = nix-project-all.nix-project-lib;
        inherit
        kaleidoscope-factory
        model01-factory
        qmk-factory
        shajra-keyboards-flash
        shajra-keyboards-lib;
    };

    pkgs = import (import ./sources.nix).nixpkgs {
        config = {};
        overlays = [overlay];
    };

    qmk-factory = fromGitHub sources.qmk "qmk-src";

    kaleidoscope-factory =
        fromGitHub sources.kaleidoscope "kaleidoscope-src";

    model01-factory = fromGitHub sources.model01 "model01-src";

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

    inherit pkgs shajra-keyboards-flash;

} // nix-project-all
