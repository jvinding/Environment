#!/bin/bash
. ~/Environment/admin
if is_admin; then
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
else
    echo Must be run as admin. Try:
	echo "su admin -c \"$0\""
fi
