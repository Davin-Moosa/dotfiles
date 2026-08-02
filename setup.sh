#!/usr/bin/env bash

# symlinks
dotdir="$HOME/dotfiles"
confs=(
  "Proton"
  "fish"
  "git"
  "mako"
  "niri"
  "nvim"
  "qt5ct"
  "qt6ct"
  "sunsetr"
  "waybar"
  "wezterm"
  "wofi"
)
if [ -d "$dotdir" ] then
  for conf in "${confs[@]}"; do
    rm -rf "$HOME/.config/$conf"
    ln -sf "$dotdir/config/$conf" "$HOME/.config/"
  done
else
  echo "No $dotdir directory"
fi
