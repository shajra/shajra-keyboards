{
  coreutils,
  curl,
  nix-project-lib,
}:
let

  name = "arduino-upgrade";
  meta.description = "Upgrade arduino JSON signatures";

  # DESIGN: Annoyingly, these signatures change rapidly upstream for what
  # appears to be an embedded timestamp.  That creates too much hash-changing
  # churn in trying to pull them in as flake inputs.

in
nix-project-lib.writeShellCheckedExe name
  {
    inherit meta;
    envKeep = [ "PRJ_ROOT" ];
    pathPackages = [
      coreutils
      curl
    ];
  }

  ''
    set -eu
    set -o pipefail

    if [ -z "$PRJ_ROOT" ]
    then
        die "PRJ_ROOT is not set; script should be run from with a devshell"
    fi

    get()
    (
        url="$1"
        dest="''${url##*/}"
        echo
        echo "GETTING LATEST: $url"
        curl \
            "$url" \
            > "$PRJ_ROOT/nix/arduino/$dest"
    )

    for url in \
        https://downloads.arduino.cc/libraries/library_index.json.sig \
        https://downloads.arduino.cc/packages/package_index.json.sig
    do get "$url"
    done
  ''
