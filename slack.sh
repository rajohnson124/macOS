#!/bin/sh
# Script to check for, download, and install Slack.

dmgfile="slack.dmg"
logfile="/Library/Logs/SlackInstallScript.log"
slack_path="/Applications/Slack.app"
url="https://slack.com/ssb/download-osx-silicon"

# Check if Slack is already installed
if [ -d "${slack_path}" ]; then
    /bin/echo "$(date): Slack is already installed." >> ${logfile}
    exit 0
fi

# Download the Slack installer
/bin/echo "$(date): Downloading Slack." >> ${logfile}
/usr/bin/curl -s -o /tmp/${dmgfile} ${url}

# Mount the installer disk image
/bin/echo "$(date): Mounting installer disk image." >> ${logfile}
mount_output=$(/usr/bin/hdiutil attach /tmp/${dmgfile} -nobrowse -quiet)
mount_point=$(echo "$mount_output" | grep -o '/Volumes/[^ ]*')

# Check if the mount was successful
if [ -z "$mount_point" ]; then
    /bin/echo "$(date): Failed to mount the disk image." >> ${logfile}
    /bin/rm /tmp/${dmgfile}
    exit 1
fi

# Install Slack
/bin/echo "$(date): Installing Slack from $mount_point." >> ${logfile}
ditto -rsrc "$mount_point/Slack.app" "${slack_path}"

/bin/sleep 10

# Unmount the installer disk image
/bin/echo "$(date): Unmounting installer disk image." >> ${logfile}
/usr/bin/hdiutil detach "$mount_point" -quiet

/bin/sleep 10

# Delete the installer disk image
/bin/echo "$(date): Deleting disk image." >> ${logfile}
/bin/rm /tmp/"${dmgfile}"

exit 0
