#!/bin/bash

# Exit immediately after error
set -e

sudo pacman -Syu

DOT_DIR="$HOME/dotfiles/"

# Install apps
echo "Installing applications"
bash "$DOT_DIR/scripts/apps.sh"

# Stow dots
echo "Stowing dots"
bash "$DOT_DIR/scripts/stowall.sh"
