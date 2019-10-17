with (import ./common);

let

    ergodoxezFactory = import ./ergodox_ez { factory = true; };
    model01Factory   = import ./model_01   { factory = true; };

    factoryBuilds = {
        ergodoxez-factory-flash = ergodoxezFactory.flash;
        ergodoxez-factory-hex   = ergodoxezFactory.hex;
        model01-factory-flash   = model01Factory.flash;
        model01-factory-hex     = model01Factory.hex;
    };

    customBuilds = id: path:
        let mkBuild = import path;
            keymaps_dir = "${path}/keymaps";
            read_keymaps = builtins.readDir keymaps_dir;
            toBuild = filename: type:
                let keymap_dir = "${keymaps_dir}/${filename}";
                    n = "${id}-custom-${filename}";
                    v = mkBuild { keymap = filename; };
                in pkgs.lib.nameValuePair n v;
         in pkgs.lib.mapAttrs' toBuild read_keymaps;

    customFlash = id: path:
        let toFlash = name: build:
            pkgs.lib.nameValuePair "${name}-flash" build.flash;
        in pkgs.lib.mapAttrs' toFlash (customBuilds id path);

    customHex = id: path:
        let toHex = name: build:
            pkgs.lib.nameValuePair "${name}-hex" build.hex;
        in pkgs.lib.mapAttrs' toHex (customBuilds id path);

in

    factoryBuilds
    // (customFlash "ergodoxez" ./ergodox_ez)
    // (customFlash "model01"   ./model_01)
    // (customHex   "ergodoxez" ./ergodox_ez)
    // (customHex   "model01"   ./model_01)
    // { licenses-thirdparty = import ./common/licenses.nix; }
