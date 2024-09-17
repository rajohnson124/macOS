#!/bin/sh
# Script to download and install Google Chrome.

dmgfile="googlechrome.dmg"
volname="Google Chrome"
logfile="/Library/Logs/GoogleChromeInstallScript.log"

Url='https://dl.google.com/dl/chrome/mac/universal/stable/gcea/googlechrome.dmg'

# Download and install
/bin/echo "$(date): Downloading latest version." >> ${logfile}
/usr/bin/curl -s -o /tmp/${dmgfile} ${Url}
/bin/echo "$(date): Mounting installer disk image." >> ${logfile}
/usr/bin/hdiutil attach /tmp/${dmgfile} -nobrowse -quiet
/bin/echo "$(date): Installing..." >> ${logfile}
ditto -rsrc "/Volumes/${volname}/Google Chrome.app" "/Applications/Google Chrome.app"
/bin/sleep 10
/bin/echo "$(date): Unmounting installer disk image." >> ${logfile}
/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "${volname}" | awk '{print $1}') -quiet
/bin/sleep 10
/bin/echo "$(date): Deleting disk image." >> ${logfile}
/bin/rm /tmp/"${dmgfile}"

exit 0
