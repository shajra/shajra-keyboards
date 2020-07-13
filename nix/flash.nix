{ coreutils
, shajra-keyboards-lib
}:

{ keyboard_id
, keyboard_desc
, prog_name
}:

let
    defaults = (import ./config.nix).default."${keyboard_id}";
in

shajra-keyboards-lib.writeShellChecked "flash-${keyboard_id}"
"Flash ${keyboard_desc} Keyboard"
''
set -eu


FACTORY=false
KEYMAP="${defaults.keymap}"
KEYMAPS_DIR="${defaults.keymaps}"
NIX_EXE="$(command -v nix || true)"


. "${shajra-keyboards-lib.lib-sh}/bin/lib.sh"

print_usage()
{
    ${coreutils}/bin/cat - <<EOF
USAGE: ${prog_name} [OPTION]...

DESCRIPTION:

    Flashes ${keyboard_desc} Keyboard

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
        --arg factory "$FACTORY" \
        --argstr keymap "$KEYMAP" \
        --arg keymaps "$(${coreutils}/bin/readlink -f "$KEYMAPS_DIR")" \
        --file "${./.}" \
        "shajra-keyboards-${keyboard_id}" \
        --command "${keyboard_id}-$SCRIPT_SUFFIX-flash"
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
            KEYMAP="''${2:-}"
            if [ -z "$KEYMAP" ]
            then die "$1 requires argument"
            fi
            shift
            ;;
        -K|--keymaps)
            KEYMAPS_DIR="''${2:-}"
            if [ -z "$KEYMAPS_DIR" ]
            then die "$1 requires argument"
            fi
            shift
            ;;
        -N|--nix)
            NIX_EXE="''${2:-}"
            if [ -z "$NIX_EXE" ]
            then die "$1 requires argument"
            fi
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
    msg="Flashing ${keyboard_desc} ($keymap_name keymap)"
    echo "$msg"
    echo "$msg" | ${coreutils}/bin/tr -c '\n' =
}


main "$@"
''
