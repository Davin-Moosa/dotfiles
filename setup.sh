#!/usr/bin/env bash

# symlinks
dotdir="$HOME/dotfiles"
confs=(
  Proton
  fish
  git
  nixos
  nvim
)
if [ -d "$dotdir" ]; then
  for conf in "${confs[@]}"; do
    ln -bs "$dotdir/config/$conf" "$HOME/.config"
  done
else
  echo "No $dotdir directory"
fi
