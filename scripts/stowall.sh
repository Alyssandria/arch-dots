#!/bin/bash

set -e

shopt -s dotglob

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
  if [[ $pkg == "scripts" ]] || [[ $pkg == ".git" ]]; then
    echo "Skipping $pkg"
    continue
  fi

  # REMOVE EXSTING ITEMS FIRST
  if [[ -e "$HOME/.config/$pkg" ]]; then
    rm -rf "$HOME/.config/$pkg"
  fi

  # REMOVE NOT INCLUDED IN .config
  for dot in "$pkg"/*; do
    # Ensure $dot is quoted to handle spaces correctly
    if [[ -f "$HOME/$(basename "$dot")" ]]; then
      echo "Removing "$HOME/$(basename "$dot")""
      rm "$HOME/$(basename "$dot")"
    fi
  done

  echo "Stowing $pkg"
  stow "$pkg"
done

echo "Done stowing"
