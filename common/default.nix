let fromGitHub = pkgs: config: name:
        with config; pkgs.fetchFromGitHub {
            inherit owner repo sha256 name;
            rev = commit;
            fetchSubmodules = true;
        };

in rec {

    config = import ../config.nix;

    thirdParty = {
        nixpkgs = with config.nixpkgs;
            builtins.fetchTarball {
                url = "https://github.com/${owner}/${repo}/tarball/${commit}";
                inherit sha256;
            };
        qmk = fromGitHub pkgs config.qmk "qmk-src";
        kaleidoscope = fromGitHub pkgs config.kaleidoscope "kaleidoscope-src";
        model01 = fromGitHub pkgs config.model01 "model01-src";
    };

    pkgs = import thirdParty.nixpkgs {};

    keymapPath = keymapsPath: keymapName:
        let readKeymaps = builtins.readDir keymapsPath;
            hasKeymap = readKeymaps ? "${keymapName}";
            isDirectory = readKeymaps.${keymapName} == "directory";
            result = "${keymapsPath}/${keymapName}";
            msgDir = "${toString keymapsPath}/${keymapName}";
            failNotFound = throw "keymap dir not found: ${msgDir}";
            failNotDir = throw "not a directory: ${msgDir}";
        in if hasKeymap
           then if isDirectory then result else failNotDir
           else failNotFound;

}
