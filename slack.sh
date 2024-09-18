#!/bin/sh
set -x  # Enable debugging

# Script to check for, download, and install Slack.

dmgfile="slack.dmg"
volname="Slack"
logfile="$HOME/SlackInstallScript.log"
slack_path="/Applications/Slack.app"
url="https://downloads.slack-edge.com/releases/macos/4.34.119/prod/arm64/Slack-4.34.119-macOS.dmg"  # Replace with your URL

# Check if Slack is already installed
if [ -d "${slack_path}" ]; then
    /bin/echo "$(date): Slack is already installed." | tee -a "${logfile}"
    exit 0
fi

# Download the Slack installer
/bin/echo "$(date): Downloading Slack." | tee -a "${logfile}"
/usr/bin/curl -fSL -o "/tmp/${dmgfile}" "${url}"
if [ $? -ne 0 ]; then
    /bin/echo "$(date): Failed to download Slack." | tee -a "${logfile}"
    exit 1
fi

# Verify the downloaded file is a valid disk image
if ! hdiutil verify "/tmp/${dmgfile}"; then
    /bin/echo "$(date): Downloaded file is not a valid disk image." | tee -a "${logfile}"
    exit 1
fi

# Mount the installer disk image
/bin/echo "$(date): Mounting installer disk image." | tee -a "${logfile}"
attach_output=$(hdiutil attach "/tmp/${dmgfile}" -nobrowse 2>&1)
if [ $? -ne 0 ]; then
    /bin/echo "$(date): Failed to mount disk image." | tee -a "${logfile}"
    /bin/echo "Error details: ${attach_output}" | tee -a "${logfile}"
    exit 1
fi

# Install Slack
/bin/echo "$(date): Installing Slack." | tee -a "${logfile}"
sudo ditto -rsrc "/Volumes/${volname}/Slack.app" "${slack_path}"
if [ $? -ne 0 ]; then
    /bin/echo "$(date): Failed to install Slack." | tee -a "${logfile}"
    exit 1
fi

# Unmount the installer disk image
/bin/echo "$(date): Unmounting installer disk image." | tee -a "${logfile}"
hdiutil detach "/Volumes/${volname}" -quiet
if [ $? -ne 0 ]; then
    /bin/echo "$(date): Failed to unmount disk image." | tee -a "${logfile}"
    exit 1
fi

# Delete the installer disk image
/bin/echo "$(date): Deleting disk image." | tee -a "${logfile}"
/bin/rm "/tmp/${dmgfile}"
if [ $? -ne 0 ]; then
    /bin/echo "$(date): Failed to delete disk image." | tee -a "${logfile}"
    exit 1
fi

exit 0
