#!/bin/bash
. ~/Environment/mac_shortcuts
if is_admin; then
    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
else
    echo Must be run as admin. Try:
	echo "su admin -c \"$0\""
fi
