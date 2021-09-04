{ coreutils
, gnutar
, gzip
, shajra-keyboards-config
, shajra-keyboards-lib
}:

{ keyboardId
, keyboardDesc
, progName
}:

let
    defaults = shajra-keyboards-config.default."${keyboardId}";
    name = "flash-${keyboardId}";
    meta.description = "Flash ${keyboardDesc} Keyboard";
in

shajra-keyboards-lib.writeShellCheckedExe name
{
    inherit meta;
    pathPure = false;
    path = [
        coreutils
        gnutar
        gzip
    ];
}
''
set -eu
set -o pipefail


FACTORY=false
KEYMAP="${defaults.keymap}"
KEYMAPS_DIR="${toString defaults.keymaps}"
NIX_EXE="$(command -v nix || true)"


. "${shajra-keyboards-lib.common}/share/nix-project/common.bash"

print_usage()
{
    cat - <<EOF
USAGE: ${progName} [OPTION]...

DESCRIPTION:

    Flashes ${keyboardDesc} Keyboard

OPTIONS:

    -h --help           print this help message
    -k --keymap KEYMAP  flash KEYMAP mapping
    -K --keymaps DIR    get keymap from keymaps directory
    -F --factory        flash factory default mapping
    -N --nix            filepath of 'nix' executable to use

    If neither -k nor -F provided, flashes the "${defaults.keymap}" mapping.
    If multiple -k switches used, then last one wins.
    The -F switch overrides -k.

EOF
}

main()
{
    parse_args "$@"
    validate_args
    print_header
    SCRIPT_SUFFIX="custom-$KEYMAP"
    if [ "$FACTORY" = "true" ]
    then SCRIPT_SUFFIX="factory"
    fi
    add_nix_to_path "$NIX_EXE"
    nix run \
        --ignore-environment \
        --keep HOME \
        --arg factory "$FACTORY" \
        --argstr keymap "$KEYMAP" \
        --arg keymaps "$(readlink -f "$KEYMAPS_DIR")" \
        --file "${./.}" \
        "build.shajra-keyboards-${keyboardId}" \
        --command "${keyboardId}-$SCRIPT_SUFFIX-flash"
}

parse_args()
{
    while ! [ "''${1:-}" = "" ]
    do
        case "$1" in
        -h|--help)
            print_usage
            exit 0
            ;;
        -F|--factory)
            FACTORY="true"
            ;;
        -k|--keymap)
            if [ -z "''${2:-}" ]
            then die "$1 requires argument"
            fi
            KEYMAP="''${2:-}"
            shift
            ;;
        -K|--keymaps)
            if [ -z "''${2:-}" ]
            then die "$1 requires argument"
            fi
            KEYMAPS_DIR="''${2:-}"
            shift
            ;;
        -N|--nix)
            if [ -z "''${2:-}" ]
            then die "$1 requires argument"
            fi
            NIX_EXE="''${2:-}"
            shift
            ;;
        *)
            die "\"$1\" not recognized"
            ;;
        esac
        shift
    done
}

validate_args()
{
    if ! [ -d "$KEYMAPS_DIR/$KEYMAP" ]
    then die "\"$KEYMAPS_DIR/$KEYMAP\" directory not found"
    fi
}

print_header()
{
    keymap_name="custom \"$KEYMAP\""
    if [ "$FACTORY" = "true" ]
    then keymap_name="factory"
    fi
    echo
    msg="Flashing ${keyboardDesc} ($keymap_name keymap)"
    echo "$msg"
    echo "$msg" | tr -c '\n' =
}


main "$@"
''
