#!/bin/bash -eu

usage() {
    echo "Usage: $0 [-v] source_dir target_dir" >&2
    echo "    -v - verbose"
    echo "    deletes any files from 'source_dir' that are duplicated in 'target_dir'" >&2
    echo "    'duplicate' is determined by filename, size and md5 sum" >&2
    echo "    RECURSES into subdirectories" >&2
}

VERBOSE=0
if [ 3 == $# ] && [ "-v" == "$1" ]; then
    VERBOSE=1
    shift
elif [ $# != 2 ]; then
    usage
    exit 1
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

__log "Source: '$SOURCE_DIR', Target: '$TARGET_DIR'"


OLDIFS=$IFS
IFS=$'\n'
files=($(find "$SOURCE_DIR" -type f))
IFS=$OLDIFS

count=${#files[@]}

__log "Checking $count files"

deleted=0
for (( i=0; i<${count}; i++ )); do
    sourceFile="${files[$i]}"
    targetFile="${TARGET_DIR}/${sourceFile##${SOURCE_DIR}/}"
    __log "Checking $sourceFile"
    if [ -f "$sourceFile" ]; then
        if [ -f "$targetFile" ]; then
            if __duplicates "$sourceFile" "$targetFile"; then
                deleted=$(($deleted + 1))
                rm "$sourceFile"
                __log "$sourceFile && $targetFile - Match, '$sourceFile' deleted"
            else
                __log "$sourceFile && $targetFile - Not a match"
            fi
        else
            __log "$targetFile - Not a file"
        fi
    else
        __log "$sourceFile - Not a file"
    fi
done

echo "$deleted files deleted"
