#!/bin/bash

# bluez and bluez-utils for Bluetooth, pipewire-pulse for wireless BT audio
driver_packages=("bluez" "bluez-utils" "pipewire-pulse")
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
	    echo "Enabling Bluetooth service..."
	    systemctl enable bluetooth.service
    else
        echo "Bluetooth service already started. Skipping..."
    fi
else
    echo "Bluetooth module not found. Skipping..."
fi

echo "Step 4 - Configuring git:"
git config --global init.defaultBranch "main"
