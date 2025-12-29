__git_merge_claude_settings() {
    local source_file="$1"
    local target_file="$2"

    if [[ -f "$source_file" ]] && [[ -f "$target_file" ]]; then
        local merged=$(jq -s '
            .[0].permissions.allow = ([.[0].permissions.allow // [], .[1].permissions.allow // []] | add | unique) |
            .[0].permissions.deny = ([.[0].permissions.deny // [], .[1].permissions.deny // []] | add | unique) |
            .[0].permissions.ask = ([.[0].permissions.ask // [], .[1].permissions.ask // []] | add | unique) |
            .[0]
        ' "$target_file" "$source_file")
        echo "$merged" > "$target_file"
        return 0
    elif [[ -f "$source_file" ]]; then
        mkdir -p "$(dirname "$target_file")"
        cp "$source_file" "$target_file"
        return 0
    fi
    return 1
}

echo "Merging ${CONDUCTOR_WORKSPACE_PATH}/.claude/settings.local.json into ${CONDUCTOR_ROOT_PATH}/.claude/settings.local.json"

if [ -z "$CONDUCTOR_ROOT_PATH" ] || [ -z "$CONDUCTOR_WORKSPACE_PATH" ]; then
    echo "CONDUCTOR_ROOT_PATH or CONDUCTOR_WORKSPACE_PATH is not set. Skipping workspace setup."
    return 0
fi

__git_merge_claude_settings "${CONDUCTOR_WORKSPACE_PATH}/.claude/settings.local.json" "${CONDUCTOR_ROOT_PATH}/.claude/settings.local.json"