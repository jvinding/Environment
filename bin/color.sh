#!/bin/bash
hex2dec() {
    local value=$(echo $1 | tr a-z A-Z)
    echo "ibase=16;obase=A;$value" | bc
}

color_percent() {
    printf "%0.2f" $(echo "scale=2;$1/255" | bc)
}


color=$1
red=$(hex2dec ${color:0:2})
green=$(hex2dec ${color:2:2})
blue=$(hex2dec ${color:4:2})
echo "[UIColor colorWithRed:$(color_percent $red) green:$(color_percent $green) blue:$(color_percent $blue) alpha:1.0]"
