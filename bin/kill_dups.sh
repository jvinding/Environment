#!/bin/bash -eu

usage() {
    echo "Usage: $0 [-v] source_dir target_dir" >&2
    echo "    -v - verbose"
    echo "    deletes any files from 'source_dir' that are duplicated in 'target_dir'" >&2
    echo "    'duplicate' is determined by filename, size and md5 sum" >&2
    echo "    DOES NOT RECURSE. All directories are left untouched"
}

if [ $# -lt 2 ]; then
    usage
    exit 1
fi

VERBOSE=0
if [ 3 == $# ]; then
    if [ "-v" == "$1" ]; then
        VERBOSE=1
        shift
    else
        usage
        exit 2
    fi
fi

SOURCE_DIR="$1"
TARGET_DIR="$2"

if ! [ -d "$SOURCE_DIR" ]; then
    echo "$SOURCE_DIR is not a directory" >&2
    exit 1
fi

if ! [ -d "$TARGET_DIR" ]; then
    echo "$TARGET_DIR is not a directory" >&2
    exit 1
fi

__verbose() {
    [ 1 == $VERBOSE ]
}

__log() {
    if __verbose; then
        echo "$1" >&2
    fi
}

__size() {
    local size=$(stat -f "%z" "$1")
    __log "$1 - Size: $size"

    echo -n $size
}

__md5() {
    local sum=$(md5 "$1" | awk '{print $NF}')
    __log "$1 - md5: $sum"

    echo $sum
}

__duplicates() {
    [ $(__size "$1") == $(__size "$2") ] && [ $(__md5 "$1") == $(__md5 "$2") ]
}

deleted=0
for s in "$SOURCE_DIR"/*; do
    __log "Checking $s"
    if [ -f "$s" ]; then
        target="${TARGET_DIR}/$(basename "$s")"
        if [ -f "$target" ]; then
            if __duplicates "$s" "$target"; then
                deleted=$(($deleted + 1))
                rm "$s"
                __log "$s && $target - Match, '$s' deleted"
            else
                __log "$s && $target - Not a match"
            fi
        else
            __log "$target - Not a file"
        fi
    else
        __log "$s - Not a file"
    fi
done

echo "$deleted files deleted"
