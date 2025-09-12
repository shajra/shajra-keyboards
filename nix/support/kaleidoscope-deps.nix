{
  arduino-cli,
  coreutils,
  eza,
  git,
  gnumake,
  nix-project-lib,
  perl,
}:
let

  name = "kaleidoscope-deps";
  meta.description = "Generate Kaleidoscope dependencies";

  # DESIGN:  We let the normal Kaleidoscope build pull down the dependencies
  # from the internet.  Then we can pin our flake inputs to the exact versions
  # used.

in
nix-project-lib.writeShellCheckedExe name
  {
    inherit meta;
    pathPackages = [
      arduino-cli
      coreutils
      eza
      git
      gnumake
      perl
    ];
    pathExtras = [
      "/bin"
    ];
  }

  ''
    set -eu
    set -o pipefail


    export KALEIDOSCOPE_DIR=/tmp/kaleidoscope
    export VERBOSE=1


    cd "$(dirname "$0")/.."

    rm -rf "$KALEIDOSCOPE_DIR"

    git clone https://github.com/keyboardio/Kaleidoscope.git \
        "$KALEIDOSCOPE_DIR"

    echo "Updating submodules"

    git -C "$KALEIDOSCOPE_DIR" submodule update --init

    cd "$KALEIDOSCOPE_DIR"

    echo "Running build"

    make -C "$KALEIDOSCOPE_DIR" setup \
        2> "/tmp/kaleidoscope.make.$(date +%Y%m%d).err" \
        > "/tmp/kaleidoscope.make.$(date +%Y%m%d).out"

    eza --tree "$KALEIDOSCOPE_DIR/.arduino/downloads/" \
        > "/tmp/kaleidoscope.deps.$(date +%Y%m%d)"
  ''
