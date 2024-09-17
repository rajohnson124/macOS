#!/bin/bash

<< ABOUT_THIS_SCRIPT
-----------------------------------------------------------------------
	Written by: Adam Martin
	@adammartin on MacAdmins Slack

	Created: February 11, 2020
    Updated: April 21, 2020
	Purpose: Downloads and installs the latest available Zoom
	app specified directly on the client. This avoids having to
	manually download and store an up-to-date installer on a
	distribution server every month.

-----------------------------------------------------------------------
ABOUT_THIS_SCRIPT

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
