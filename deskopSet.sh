#!/bin/bash

# Script to install Homebrew, desktoppr, and set a random desktop background on macOS.
# Author: Your Name
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

# Check if the script is running as root and exit if true
if [ "$EUID" -eq 0 ]; then
    log "This script should not be run as root or with sudo. Please run it as a regular user."
    exit 1
fi

# Function to install Homebrew if it is not installed
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >/dev/null 2>&1
        
        # Validate installation
        if command -v brew &> /dev/null; then
            log "Homebrew installed successfully."
        else
            log "Failed to install Homebrew. Exiting."
            exit 1
        fi
    else
        log "Homebrew is already installed."
    fi
}

# Function to install desktoppr using Homebrew
install_desktoppr() {
    if ! command -v $DESKTOPPR_PATH &> /dev/null; then
        log "desktoppr is not installed. Installing desktoppr..."
        # Update Homebrew and install desktoppr
        brew update >/dev/null 2>&1
        brew install --cask desktoppr >/dev/null 2>&1
        
        # Validate installation
        if command -v $DESKTOPPR_PATH &> /dev/null; then
            log "desktoppr installed successfully."
        else
            log "Failed to install desktoppr. Exiting."
            exit 1
        fi
    else
        log "desktoppr is already installed."
    fi
}

# Function to set the desktop background using desktoppr
set_background() {
    # Select a random URL from the array
    RANDOM_URL=${IMAGE_URLS[$RANDOM % ${#IMAGE_URLS[@]}]}
    
    log "Setting the desktop background to the image from the URL: $RANDOM_URL"
    $DESKTOPPR_PATH "$RANDOM_URL" >/dev/null 2>&1
    
    # Validate background change
    if [ $? -eq 0 ]; then
        log "Desktop background successfully updated."
    else
        log "Failed to set the desktop background."
        exit 1
    fi
}

# Main script execution
log "Starting the background setter script."
install_homebrew
install_desktoppr
set_background
log "Script completed successfully."

exit 0
