#!/bin/bash

display_greeting() {
    cat << "EOF"
 ______ _____ ______  _____  ___  ___   ___  _____  _   _  __   _   _  _____               
|___  /|____ || ___ \|  _  | |  \/  |  /   |/  __ \| | | |/  | | \ | ||____ |              
   / /     / /| |_/ /| |/' | | .  . | / /| || /  \/| |_| |`| | |  \| |    / /              
  / /      \ \|    / |  /| | | |\/| |/ /_| || |    |  _  | | | | . ` |    \ \              
./ /___.___/ /| |\ \ \ |_/ / | |  | |\___  || \__/\| | | |_| |_| |\  |.___/ /              
\_____/\____/ \_| \_| \___/  \_|  |_/    |_/ \____/\_| |_/\___/\_| \_/\____/               
                                                                                                                                                                              
                                                                                           
 _____  _____  _   _ ______  _____  _____  _   _ ______   ___   _____  _____  _____  _   _ 
/  __ \|  _  || \ | ||  ___||_   _||  __ \| | | || ___ \ / _ \ |_   _||_   _||  _  || \ | |
| /  \/| | | ||  \| || |_     | |  | |  \/| | | || |_/ // /_\ \  | |    | |  | | | ||  \| |
| |    | | | || . ` ||  _|    | |  | | __ | | | ||    / |  _  |  | |    | |  | | | || . ` |
| \__/\\ \_/ /| |\  || |     _| |_ | |_\ \| |_| || |\ \ | | | |  | |   _| |_ \ \_/ /| |\  |
 \____/ \___/ \_| \_/\_|     \___/  \____/ \___/ \_| \_|\_| |_/  \_/   \___/  \___/ \_| \_/

EOF
}

clear
display_greeting

# Exit on any error
set -e

# bluez and bluez-utils for Bluetooth, pipewire-pulse for wireless BT audio
driver_packages=("bluez" "bluez-utils")
system_packages=("man-db" "zip" "wofi" "waybar" "ttf-font-awesome" "nftables")
development_packages=("zsh" "git" "github-cli" "code" "go")
productivity_packages=(
	"chromium" 
	"libreoffice-still" 
	"libreoffice-still-pt" 
	"vlc")

echo "Step 1 - Package database update:"
echo "Updating package database..."
pacman -Sy --noconfirm

echo "Step 2 - Install requirement packages:"
echo "Installing driver packages..."
pacman -S --noconfirm --needed "${driver_packages[@]}"
echo "Installing system packages..."
pacman -S --noconfirm --needed "${system_packages[@]}"
echo "Installing development packages..."
pacman -S --noconfirm --needed "${development_packages[@]}"
echo "Installing productivity packages..."
pacman -S --noconfirm --needed "${productivity_packages[@]}"

echo "Step 3 - Configuring required services:"

echo "Configuring bluetooth..."
if lsmod | grep btusb; then
    if [[ "$(systemctl is-enabled bluetooth.service 2>/dev/null)" != "enabled" ]]; 
    then
	    echo "Starting Bluetooth service..."
        systemctl start bluetooth.service
	    echo "Enabling Bluetooth service (for auto-starting when booting)..."
	    systemctl enable bluetooth.service
    else
        echo "Bluetooth service already started. Skipping..."
    fi
else
    echo "Bluetooth module not found. Skipping..."
fi

echo "Configuring firewall..."
echo "Copying firewall configuration"
cp firewall/nftables.conf /etc/nftables.conf

if [[ "$(systemctl is-enabled nftables.service 2>/dev/null)" != "enabled" ]];
then
    echo "Starting Firewall service..."
    systemctl start nftables.service
    echo "Enabling Firewall service (for auto-starting when booting)..."
    systemctl enable nftables.service
else
    echo "Firewall already configured. Skipping..."
fi


echo "Step 4 - Configuring git:"
git config --global init.defaultBranch "main"
