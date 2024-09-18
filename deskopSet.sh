#!/bin/bash

# Script to check for desktoppr and set a random desktop background on macOS.
# Author: Ryan Johnson
# Date: 2024-09-17

# Define an array of URLs for the images
IMAGE_URLS=(
    "https://www.dropbox.com/scl/fi/2pia5b2oeof4rffrqvx6v/Gecko-Background-Dark-Desktop-Corrosion.png?rlkey=ab3e3hvv6zm3h75s5vdh7vakw&st=gfyzxi5w&dl=1"
    "https://www.dropbox.com/scl/fi/2pia5b2oeof4rffrqvx6v/Gecko-Background-Dark-Desktop-Corrosion.png?rlkey=ab3e3hvv6zm3h75s5vdh7vakw&st=dck20lo8&dl=1"
    "https://www.dropbox.com/scl/fi/fkkn0i541cxz3lsuv94p4/Gecko-Background-Dark-Desktop-TOKA-5-3.png?rlkey=xfadtzmetc1kq2fl0brjmdn5z&st=gd2r7dw3&dl=1"
    "https://www.dropbox.com/scl/fi/fkkn0i541cxz3lsuv94p4/Gecko-Background-Dark-Desktop-TOKA-5-3.png?rlkey=xfadtzmetc1kq2fl0brjmdn5z&st=gd2r7dw3&dl=1"
)

# Path to the desktoppr binary
DESKTOPPR_PATH="/usr/local/bin/desktoppr"

# Function to output messages to the console
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Get the currently logged-in user
loggedInUser=$(echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }')

# Check if a user is logged in
if [ "$loggedInUser" == "loginwindow" ] || [ -z "$loggedInUser" ]; then
    log "No logged-in user detected. Exiting."
    exit 1
fi

# Function to check if desktoppr exists at the specified path
check_desktoppr() {
    if [ -x "$DESKTOPPR_PATH" ]; then
        log "desktoppr is found at $DESKTOPPR_PATH."
    else
        log "desktoppr is not found at $DESKTOPPR_PATH. Please ensure it is installed correctly."
        exit 1
    fi
}

# Function to set the desktop background using desktoppr
set_background() {
    # Select a random URL from the array
    RANDOM_URL=${IMAGE_URLS[RANDOM % ${#IMAGE_URLS[@]}]}
    
    log "Setting the desktop background to the image from the URL: $RANDOM_URL"
    
    # Run desktoppr as the logged-in user
    sudo -u "$loggedInUser" "$DESKTOPPR_PATH" "$RANDOM_URL" >/dev/null 2>&1
    
    # Validate background change
    if [ $? -eq 0 ]; then
        log "Desktop background successfully updated for $loggedInUser."
    else
        log "Failed to set the desktop background."
        exit 1
    fi
}

# Main script execution
log "Starting the background setter script."
check_desktoppr
set_background
log "Script completed successfully."

exit 0
