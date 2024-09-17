#!/bin/sh
# Script to check for, download, and install Slack.

dmgfile="slack.dmg"
volname="Slack"
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
/usr/bin/hdiutil attach /tmp/${dmgfile} -nobrowse -quiet

# Install Slack
/bin/echo "$(date): Installing Slack." >> ${logfile}
ditto -rsrc "/Volumes/${volname}/Slack.app" "${slack_path}"

/bin/sleep 10

# Unmount the installer disk image
/bin/echo "$(date): Unmounting installer disk image." >> ${logfile}
/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "${volname}" | awk '{print $1}') -quiet

/bin/sleep 10

# Delete the installer disk image
/bin/echo "$(date): Deleting disk image." >> ${logfile}
/bin/rm /tmp/"${dmgfile}"

exit 0
