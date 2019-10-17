{ nix_expr
, keyboard_id
, keyboard_desc
, prog_name
, path
}:

let pkgs = (import ./.).pkgs;
    default_keymap = 
        (import ../config.nix).default.keymap."${keyboard_id}";
in

pkgs.writeShellScriptBin "flash-run"
''
set -e
set -u

FACTORY=false
DEFAULT_KEYMAP=${default_keymap}
KEYMAP="$DEFAULT_KEYMAP"

main()
{
    parse_args "${keyboard_desc}" "$@"
    validate_args
    print_header "${keyboard_desc}"
    SCRIPT_SUFFIX="custom-$KEYMAP"
    if [ "$FACTORY" = "true" ]
    then SCRIPT_SUFFIX="factory"
    fi
    PATH="${path}" nix run \
        --ignore-environment \
        --arg factory "$FACTORY" \
        --argstr keymap "$KEYMAP" \
        --file "${nix_expr}" \
        --command "${keyboard_id}-$SCRIPT_SUFFIX-flash"
}

setup()
{
    keyboard_desc="$1"
    shift
    parse_args "$keyboard_desc" "$@"
    print_header "$keyboard_desc"
}

parse_args()
{
    keyboard_desc="$1"
    shift 1
    while ! [ "''${1:-}" = "" ]
    do
        case "$1" in
        -h|--help)
            print_usage "$keyboard_desc"
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
        *)
            die "\"$1\" not recognized"
            ;;
        esac
        shift
    done
}

validate_args()
{
    if ! [ -d "${nix_expr}/keymaps/$KEYMAP" ]
    then die "\"${nix_expr}/keymaps/$KEYMAP\" directory not found"
    fi
}

print_header()
(
    keyboard_desc="$1"
    keymap_name="custom \"$KEYMAP\""
    if [ "$FACTORY" = "true" ]
    then keymap_name="factory"
    fi
    echo
    msg="Flashing $keyboard_desc ($keymap_name keymap)"
    echo "$msg"
    echo "$msg" | ${pkgs.coreutils}/bin/tr -c '\n' =
)

print_usage()
(
    keyboard_desc="$1"
    ${pkgs.coreutils}/bin/cat - <<EOF
USAGE: ${prog_name} [OPTION]...

DESCRIPTION:

    Flashes $keyboard_desc Keyboard

OPTIONS:

    -h, --help           print this help message
    -k, --keymap KEYMAP  flash KEYMAP mapping
    -F, --factory        flash factory default mapping

    If neither -k nor -F provided, flashes the "$DEFAULT_KEYMAP" mapping.
    If multiple -k switches used, then last one wins.
    The -F switch overrides -k.

EOF
)

die()
{
    print_usage "$keyboard_desc" >&2
    echo
    echo "ERROR: $1" >&2
    exit 1
}

main "$@"
''
