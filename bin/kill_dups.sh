#!/bin/bash -eu

if [ 2 != $# ]; then
    echo "Usage: $0 source_dir target_dir" >&2
    echo "    deletes any files from 'source_dir' that are duplicated in 'target_dir'" >&2
    echo "    'duplicate' is determined by filename, size and md5 sum" >&2
    echo "    DOES NOT RECURSE. All directories are left untouched"
fi

SOURCE_DIR=$1
TARGET_DIR=$2

if ! [ -d "$1" ]; then
    echo "$1 is not a directory" >&2
    exit 1
fi

if ! [ -d "$2" ]; then
    echo "$2 is not a directory" >&2
    exit 1
fi

__size() {
    stat -f "%z" "$1"
}

__md5() {
    md5 "$1" | awk '{print $NF}'
}

__duplicates() {
    [ $(__size "$1") == $(__size "$2") ] && [ $(__md5 "$1") == $(__md5 "$2") ]
}

for s in $SOURCE_DIR/*; do
    if [ -f "$s" ]; then
        target="${TARGET_DIR}/$(basename "$s")"
        if [ -f "$target" ] && __duplicates "$s" "$target"; then
            rm "$s"
        fi
    fi
done
