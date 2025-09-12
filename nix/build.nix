{
  lib,
  shajra-keyboards-builder,
  shajra-keyboards-keymaps,

}:

let

  flattenBuilds = lib.concatMapAttrs (
    name: build: {
      "${name}-flash" = build.flash;
      "${name}-hex" = build.hex;
    }
  );

  buildCustom =
    keymapsSource: id: builder:
    let
      keymaps = shajra-keyboards-keymaps."${keymapsSource}"."${id}";
      toBuild =
        keymap: type:
        if type == "directory" then
          {
            "${id}-${keymapsSource}-${keymap}" = builder {
              factory = false;
              inherit keymap keymaps keymapsSource;
            };
          }
        else
          { };
    in
    lib.concatMapAttrs toBuild (builtins.readDir keymaps);

  builds.factory =
    let
      f = id: builder: {
        "${id}-factory" = builder { factory = true; };
      };
    in
    lib.concatMapAttrs f shajra-keyboards-builder;

  builds.builtin = lib.concatMapAttrs (buildCustom "builtin") shajra-keyboards-builder;
  builds.input = lib.concatMapAttrs (buildCustom "input") shajra-keyboards-builder;

in
flattenBuilds (lib.foldl lib.mergeAttrs { } (builtins.attrValues builds))
