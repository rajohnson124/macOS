#!/bin/bash
# Script to check for, download, and install Zoom.

# Full URL of the Zoom installer
url="https://zoom.us/client/latest/ZoomInstallerIT.pkg"
logfile="/Library/Logs/ZoomInstallScript.log"
zoom_path="/Applications/zoom.us.app"

# Change directory to /private/tmp to make this the working directory
cd /private/tmp/

# Check if Zoom is already installed
if [ -d "${zoom_path}" ]; then
    /bin/echo "$(date): Zoom is already installed." >> ${logfile}
    exit 0
fi

# Download the installer package
/bin/echo "$(date): Downloading Zoom installer." >> ${logfile}
/usr/bin/curl -JL "$url" -o "ZoomInstallerIT.pkg"

# Install the package
/bin/echo "$(date): Installing Zoom." >> ${logfile}
/usr/sbin/installer -pkg "ZoomInstallerIT.pkg" -target /

# Remove the installer package when done
/bin/echo "$(date): Deleting installer package." >> ${logfile}
/bin/rm -f "ZoomInstallerIT.pkg"

exit 0
