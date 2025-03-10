#!/bin/bash

driver_packages=("bluez" "bluez-utils")
system_packages=("man-db" "zip" "wofi" "waybar" "ttf-font-awesome")
development_packages=("zsh" "git" "github-cli" "code")
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

echo "Configuring git..."
# git config --global init.defaultBranch "main"
