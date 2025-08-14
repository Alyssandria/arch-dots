#!/bin/bash

set -e

DOTS_DIR="$HOME/dotfiles"

# Make sure Stow is installed
if ! command -v stow &>/dev/null; then
  echo "Installing GNU Stow..."
  sudo yay -S stow # change to pacman/dnf if needed
fi

cd "$DOTS_DIR"

# Stow all
for pkg in */; do
  pkg="${pkg%/}"
  if [[ $pkg == "scripts" ]]; then
    echo "Skipping scripts"
    continue
  fi

  echo "Stowing $pkg"
  stow "$pkg"
done

echo "Done stowing"
