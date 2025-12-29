#!/usr/bin/env bash
__git_copy_to_worktree() {
    local source_base="$1"
    local target_base="$2"
    local path="$3"

    [[ -e "${source_base}/${path}" ]] || return 0

    if [[ -d "${source_base}/${path}" ]]; then
        # Use ditto for directory copying - it handles merging correctly on macOS
        /usr/bin/ditto "${source_base}/${path}" "${target_base}/${path}"
    elif [[ ! -e "${target_base}/${path}" ]]; then
        local parent=$(/usr/bin/dirname "${target_base}/${path}")
        [[ -d "$parent" ]] || /bin/mkdir -p "$parent"
        /bin/cp -c "${source_base}/${path}" "${target_base}/${path}"
    fi
}

local files_to_copy=(
    .claude
    .env
    node_modules
    .vscode
    .specify
    specs
    config/master.key
    .dockerdev/compose.override.yml
)

echo "Copying workspace files from ${CONDUCTOR_ROOT_PATH} to ${CONDUCTOR_WORKSPACE_PATH}"

if [ -z "$CONDUCTOR_ROOT_PATH" ] || [ -z "$CONDUCTOR_WORKSPACE_PATH" ]; then
    echo "CONDUCTOR_ROOT_PATH or CONDUCTOR_WORKSPACE_PATH is not set. Skipping workspace setup."
    return 0
fi

for path in "${files_to_copy[@]}"; do
    __git_copy_to_worktree "$CONDUCTOR_ROOT_PATH" "$CONDUCTOR_WORKSPACE_PATH" "$path"
done