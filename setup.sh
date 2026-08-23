#!/usr/bin/env bash

# symlinks
dotdir="$HOME/dotfiles"
confs=(
  Proton
  fish
  git
  nvim
)
if [ -d "$dotdir" ]; then
  for conf in "${confs[@]}"; do
    ln -sf "$dotdir/config/$conf" "$HOME/.config/"
  done
else
  echo "No $dotdir directory"
fi
