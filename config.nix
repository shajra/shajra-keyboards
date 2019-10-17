# This configuration has pointers to the repositories/commits used for a
# consistent build using Nix.
#
# You can point to a different repository or change the commit, but if you do,
# the calculated SHA256 hash will likely change.  Just put in a bogus hash, and
# when you build/flash, Nix will tell you what the calculated hash is.  If you
# don't change the SHA256 hash, Nix will reuse the prior build saved to that
# hash.

{

    # You can make your own keymap on the side, rather than modify the "shajra"
    # keymap, and then change the default keymaps of the flashing scripts here.
    #
    default.keymap.ergodoxez = "shajra";
    default.keymap.model01 = "shajra";

    # Nixpkgs GitHub Repository
    #
    # This repository specifies pinned versions of all the tools available to
    # Nix.  The various ".nix" files in this project use this repository to pull
    # different depedencies needed to build QMK and Kaleidoscope firmware.
    #
    nixpkgs = {
        owner = "NixOS";
        repo = "nixpkgs-channels";
        commit = "1f56d679f4012a906b9288c27ab4ff4de1405ee3";
        sha256 = "04hvj002s01h5ah9krpri0dvq4n6i5gs5dvivdybmhh3naqk7msd";
    };

    # QMK Firmware GitHub Repository (for Ergodox EZ)
    #
    # Users normally publish their keymaps directly into this repository.
    # Instead, we use Nix to get this repository and patch our keymap into it
    # locally.
    #
    qmk = {
        owner = "qmk";
        repo = "qmk_firmware";
        commit = "20a16d29fe50f30b8309e68790c628832dc4906c";
        #sha256 = "1j2spsnxlzdyb0sla5vx2d8bh773s2gwh5mv68j8xa4hyhmw59k7";
        sha256 = "1bdimmisq157l4b47agvgcxcc7pvwrmpi3q30psa10rxzx99ip1w";
    };

    # Kaleidoscope Arduino Framework GitHub Repository (for Keyboardio)
    #
    # This is code for the Arduino in the Keyboardio Model 01 hardware.
    #
    kaleidoscope = {
        owner = "keyboardio";
        repo = "Kaleidoscope-Bundle-Keyboardio";
        commit = "475659a6e36cec3142f3cdceffa6e166332d8a5b";
        #sha256 = "0krgj1c4ix17gf285x8s9pg1rhgw2lijv3hclbfmgmnlqkvxwphv";
        sha256 = "0n2f82xxrxvdw7c5kqcdp611wmn38q1x1pnkjigskx8g1v1klwwj";
    };

    # Keyboardio Model 01 Firmware GitHub Repository
    #
    # Keyboardio factored the firmware into a separate repository.
    #
    model01 = {
        owner = "keyboardio";
        repo = "Model01-Firmware";
        commit = "4299824b114a001fd74ae790669ff0d39563d62d";
        #sha256 = "0gm6lh39j2j8hvzy74sfviw96kv24rngsglpd48avzv434r1bkj0";
        sha256 = "08ql995bdg5r1lndvdbmx2pfn8f2a6n58p2q8r6bkf81hy51kfa4";
    };

}
