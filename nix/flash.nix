{
  coreutils,
  git,
  gnused,
  gnutar,
  gzip,
  lib,
  nix-project-lib,
  shajra-keyboards-keymaps,
  shajra-keyboards-keymap,

}:

{
  keyboardId,
  keyboardDesc,
  progName,
}:

let

  name = "flash-${keyboardId}";
  meta.description = "Flash ${keyboardDesc} Keyboard";
  filterSrc =
    p:
    lib.sourceFilesBySuffices p [
      ".lock"
      ".nix"
      ".jq"
      ".json"
      ".h"
      ".c"
      ".ino"
    ];
  builtinKeymaps = toString (filterSrc shajra-keyboards-keymaps.builtin."${keyboardId}");
  defaultKeymap = shajra-keyboards-keymap."${keyboardId}";

in
nix-project-lib.writeShellCheckedExe name
  {
    inherit meta;
    envKeep = [ "HOME" ];
    pathKeep = [ "nix" ];
    pathPackages = [
      coreutils
      git
      gnused
      gnutar
      gzip
    ];
  }
  ''
    set -eu
    set -o pipefail


    FACTORY=false
    KEYMAPS_SOURCE=builtin
    KEYMAP="${defaultKeymap}"
    KEYMAPS_DIR="${builtinKeymaps}"


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

        If neither -k nor -F provided, flashes the "${defaultKeymap}" mapping.
        If multiple -k switches used, then last one wins.
        The -F switch overrides -k.

    EOF
    }

    main()
    {
        parse_args "$@"
        validate_args
        print_header

        WARN_REGEX="warning: not writing modified lock file of flake"
        WARN_REGEX+="\|trace: using non-memoized"
        {
            if [ "$KEYMAPS_SOURCE" = input ]
            then do_flash --override-input "keymaps-${keyboardId}" "path:$KEYMAPS_DIR"
            else do_flash
            fi
        } 2> >(sed "/$WARN_REGEX/d; /• Updated input/{N;N;d;}">&2)
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
                KEYMAPS_SOURCE=input
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

    do_flash()
    {
        SCRIPT_SUFFIX="$KEYMAPS_SOURCE-$KEYMAP"
        if [ "$FACTORY" = "true" ]
        then SCRIPT_SUFFIX="factory"
        fi
        SCRIPT_NAME="${keyboardId}-$SCRIPT_SUFFIX-flash"
        nix --extra-experimental-features "nix-command flakes" \
            shell \
            --ignore-environment \
            --keep HOME \
            "$@" \
            "${filterSrc ../.}#nixpkgs.shajra-keyboards-build.$SCRIPT_NAME" \
            --command "$SCRIPT_NAME"
    }


    main "$@"
  ''
