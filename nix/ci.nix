{ lib
, linkFarm
, shajra-keyboards-build
, shajra-keyboards-flash-scripts
, shajra-keyboards-licenses
}:

let

    prefixNames = prefix: set: lib.listToAttrs (builtins.map (name:
        { name = prefix + name; value = set.${name}; }
    ) (lib.attrNames set));

    included = {}
        // (prefixNames "build-" shajra-keyboards-build)
        // (prefixNames "flash-" shajra-keyboards-flash-scripts)
        // { licenses = shajra-keyboards-licenses; };

in linkFarm "shajra-keyboards-ci"
    (lib.filterAttrs (lib.const lib.isDerivation) included)
