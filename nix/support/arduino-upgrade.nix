{
  coreutils,
  curl,
  jq,
  nix-project-lib,
}:
let

  name = "arduino-upgrade";
  meta.description = "Upgrade arduino JSON signatures";

in
nix-project-lib.writeShellCheckedExe name
  {
    inherit meta;
    envKeep = [ "PRJ_ROOT" ];
    pathPackages = [
      coreutils
      curl
      jq
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
        echo >&2
        echo "GETTING LATEST: $url" >&2
        curl -s "$url"
    )

    dest="package_index.json"
    final_file="$PRJ_ROOT/nix/arduino/$dest"
    get "https://downloads.arduino.cc/packages/package_index.json" \
        | jq -f "${./arduino-lib-prune.jq}" > "$final_file"
    echo "WROTE: $final_file"
  ''
