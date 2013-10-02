#!/bin/bash
. ~/Environment/mac_shortcuts
if is_admin; then
    brew install ack git bash-completion
else
    echo must be run as admin
fi
