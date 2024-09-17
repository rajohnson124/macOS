#!/bin/bash

# this is the full URL
url="https://zoom.us/client/latest/ZoomInstallerIT.pkg"

# change directory to /private/tmp to make this the working directory
cd /private/tmp/

# download the installer package and name it for the linkID
/usr/bin/curl -JL "$url" -o "ZoomInstallerIT.pkg"

# install the package
/usr/sbin/installer -pkg "ZoomInstallerIT.pkg" -target /

# remove the installer package when done
/bin/rm -f "ZoomInstallerIT.pkg"

exit 0
