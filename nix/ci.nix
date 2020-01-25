with (import ./.);

let

    ergodoxezFactory = shajra-keyboards-ergodoxez {
        factory = true;
    };

    model01Factory = shajra-keyboards-model01 {
        factory = true;
    };

    buildsFactory = {
        ergodoxez-factory-flash = ergodoxezFactory.flash;
        ergodoxez-factory-hex   = ergodoxezFactory.hex;
        model01-factory-flash   = model01Factory.flash;
        model01-factory-hex     = model01Factory.hex;
    };

    matchId = ifErgodoxEz: ifModel01: id:
        if id == "ergodoxez"
        then ifErgodoxEz
        else if id == "model01"
        then ifModel01
        else throw ("unknown ID: " + id);

    keymaps = matchId ../keymaps/ergodox_ez ../keymaps/model_01;

    ergodoxezCustom = shajra-keyboards-ergodoxez;

    model01Custom = shajra-keyboards-model01;

    builderCustom = matchId ergodoxezCustom model01Custom;

    buildsCustom = id:
        let read_keymaps = builtins.readDir (keymaps id);
            toBuild = filename: type:
                let n = "${id}-custom-${filename}";
                    v = builderCustom id {
                        factory = false;
                        keymap = filename;
                    };
                in pkgs.lib.nameValuePair n v;
         in pkgs.lib.mapAttrs' toBuild read_keymaps;

    flashCustom = id:
        let toFlash = name: build:
                pkgs.lib.nameValuePair "${name}-flash" build.flash;
        in pkgs.lib.mapAttrs' toFlash (buildsCustom id);

    hexCustom = id:
        let toHex = name: build:
                pkgs.lib.nameValuePair "${name}-hex" build.hex;
        in pkgs.lib.mapAttrs' toHex (buildsCustom id);

in

    buildsFactory
    // (flashCustom "ergodoxez")
    // (flashCustom "model01")
    // (hexCustom   "ergodoxez")
    // (hexCustom   "model01")
    // shajra-keyboards-flash-scripts
    // { inherit shajra-keyboards-licenses; }
