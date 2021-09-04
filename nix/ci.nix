with (import ./. {});

let

    lib = nixpkgs-stable.lib;

    ergodoxezFactory  = build.shajra-keyboards-ergodoxez  { factory = true; };
    model01Factory    = build.shajra-keyboards-model01    { factory = true; };
    moonlanderFactory = build.shajra-keyboards-moonlander { factory = true; };

    buildsFactory = {
        ergodoxez-factory-flash    = ergodoxezFactory.flash;
        ergodoxez-factory-hex      = ergodoxezFactory.hex;
        model01-factory-flash      = model01Factory.flash;
        model01-factory-hex        = model01Factory.hex;
        moonlander-factory-flash   = moonlanderFactory.flash;
        moonlander-factory-hex     = moonlanderFactory.hex;
    };

    matchId = ifErgodoxEz: ifModel01: ifMoonlander: id:
        if id == "ergodoxez"
        then ifErgodoxEz
        else if id == "model01"
        then ifModel01
        else if id == "moonlander"
        then ifMoonlander
        else throw ("unknown ID: " + id);

    keymaps = matchId ../keymaps/ergodox_ez ../keymaps/model_01 ../keymaps/moonlander;

    ergodoxezCustom  = build.shajra-keyboards-ergodoxez;
    model01Custom    = build.shajra-keyboards-model01;
    moonlanderCustom = build.shajra-keyboards-moonlander;

    builderCustom = matchId ergodoxezCustom model01Custom moonlanderCustom;

    buildsCustom = id:
        let read_keymaps = builtins.readDir (keymaps id);
            toBuild = filename: type:
                let n = "${id}-custom-${filename}";
                    v = builderCustom id {
                        factory = false;
                        keymap = filename;
                    };
                in lib.nameValuePair n v;
         in lib.mapAttrs' toBuild read_keymaps;

    flashCustom = id:
        let toFlash = name: build:
                lib.nameValuePair "${name}-flash" build.flash;
        in lib.mapAttrs' toFlash (buildsCustom id);

    hexCustom = id:
        let toHex = name: build:
                lib.nameValuePair "${name}-hex" build.hex;
        in lib.mapAttrs' toHex (buildsCustom id);

in

    buildsFactory
    // (flashCustom "ergodoxez")
    // (flashCustom "model01")
    // (flashCustom "moonlander")
    // (hexCustom   "ergodoxez")
    // (hexCustom   "model01")
    // (hexCustom   "moonlander")
    // build.shajra-keyboards-flash-scripts
    // { inherit (build) shajra-keyboards-licenses; }
