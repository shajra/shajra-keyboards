RUN_NIX="$PROJECT_ROOT/common/run.nix"


nix run \
    --ignore-environment \
    --argstr nix_expr "$BUILD_NIX" \
    --argstr keyboard_id "$KEYBOARD_ID" \
    --argstr keyboard_desc "$KEYBOARD_DESC" \
    --argstr prog_name "$(basename "$0")" \
    --argstr path "$PATH" \
    --file "$RUN_NIX" \
    --command flash-run \
    "$@"
