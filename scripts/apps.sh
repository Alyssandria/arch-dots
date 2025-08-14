#!/bin/bash

set -e

# Install brave browser

echo "Installing Brave ..."
curl -fsS https://dl.brave.com/install.sh | sh

# BRAVE SETTINGS
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

# SET DEFAULT BROWSER
echo "Setting Brave as default web browser"
xdg-settings set default-web-browser brave-browser.desktop

echo "Installing Starship ..."
curl -sS https://starship.rs/install.sh | sh
