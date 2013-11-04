#!/bin/bash
. ~/Environment/admin
if is_admin; then
    brew install ack git bash-completion
else
    echo Must be run as admin. Try:
	echo "su admin -c \"$0\""
fi