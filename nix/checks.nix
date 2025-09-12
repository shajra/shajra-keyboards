{
  lib,
  linkFarm,
  shajra-keyboards-build,
  shajra-keyboards-flash-scripts,
  shajra-keyboards-licenses,
  shajra-keyboards-support-arduino-upgrade,
  shajra-keyboards-support-kaleidoscope-deps,
}:

let

  prefixNames =
    prefix: set:
    lib.listToAttrs (
      builtins.map (name: {
        name = prefix + name;
        value = set.${name};
      }) (lib.attrNames set)
    );

  included =
    { }
    // (prefixNames "build-" shajra-keyboards-build)
    // (prefixNames "flash-" shajra-keyboards-flash-scripts)
    // {
      licenses = shajra-keyboards-licenses;
      support-arduino-upgrade = shajra-keyboards-support-arduino-upgrade;
      support-kaleidoscope-deps = shajra-keyboards-support-kaleidoscope-deps;
    };

in
linkFarm "shajra-keyboards-checks" (lib.filterAttrs (lib.const lib.isDerivation) included)
