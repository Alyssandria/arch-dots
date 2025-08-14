#!/bin/bash

# Exit immediately after error
set -e

sudo pacman -Syu

# Install apps
./apps.sh
