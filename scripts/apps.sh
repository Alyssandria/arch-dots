#!/bin/bash

set -e

# Install brave browser
if ! command -v brave &>/dev/null; then
  echo "Installing Brave..."
  curl -fsS https://dl.brave.com/install.sh | sh
fi

echo "Brave Installed..."

# BRAVE SETTINGS
if [[ ! -f "$HOME/.local/share/applications/brave-browser.desktop" ]]; then
  echo "Creating brave-browser.desktop settings"
  cat <<EOF >>"$HOME/.local/share/applications/brave-browser.desktop"
[Desktop Entry]
Version=1.0
Name=Brave Browser
Comment=Browse the web with privacy
Exec=/usr/bin/brave --ozone-platform=wayland %U
Icon=brave
Terminal=false
Type=Application
Categories=Network;WebBrowser;
StartupWMClass=Brave
MimeType=x-scheme-handler/unknown;x-scheme-handler/about;x-scheme-handler/https;x-scheme-handler/http;text/html;
EOF
fi

# SET DEFAULT BROWSER
echo "Setting Brave as default web browser"
xdg-settings set default-web-browser brave-browser.desktop

# INSTALL STARSHIP
if ! command -v starship &>/dev/null; then
  echo "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh
fi

echo "DONE"
