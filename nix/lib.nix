{
  nix-project-lib,
}:

nix-project-lib
// {
  keymapPath =
    keymapsPath: keymapName:
    let
      readKeymaps = builtins.readDir keymapsPath;
      hasKeymap = readKeymaps ? "${keymapName}";
      isDirectory = readKeymaps.${keymapName} == "directory";
      result = "${keymapsPath}/${keymapName}";
      msgDir = "${toString keymapsPath}/${keymapName}";
      failNotFound = throw "keymap dir not found: ${msgDir}";
      failNotDir = throw "not a directory: ${msgDir}";
    in
    if hasKeymap then if isDirectory then result else failNotDir else failNotFound;
}
