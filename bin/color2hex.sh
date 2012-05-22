#!/bin/bash

color_value() {
    local value=$(echo "255 * $1" | bc)
    echo ${value%%.*}
}

red=$(color_value $1)
green=$(color_value $2)
blue=$(color_value $3)
printf "#%02x%02x%02x" $red $green $blue
