#!/bin/bash

usage() {
    echo you must run this script from the Environment directory
}

if [ ! -d dot_files ]; then
    usage
    exit 1;
fi

dir=$(pwd)
dir=${dir##${HOME}/}

cd ~
for s in $dir/dot_files/*; do
    target=.${s##*/}
    if [ -L $target ]; then
        rm $target
    fi
    if [ -e $target ]; then
        echo Skipping $target
    else
        ln -s $s $target
    fi
done
