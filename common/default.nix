rec {

    config = import ../config.nix;

    pkgs =
        let nixpkgsPath = with config.nixpkgs;
            builtins.fetchTarball {
                url = "https://github.com/${owner}/${repo}/tarball/${commit}";
                inherit sha256;
            };
        in import nixpkgsPath {};

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
