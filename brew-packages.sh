#!/bin/bash
. ~/Environment/admin
if is_admin; then
    brew install ack git bash-completion git-flow

    # cask
    brew tap phinze/cask
    brew install brew-cask

    # shell extensions
    brew install z

    # quicklook plugins
    brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql webp-quicklook suspicious-package
else
    echo Must be run as admin. Try:
    echo "su admin -c \"$0\""
fi
