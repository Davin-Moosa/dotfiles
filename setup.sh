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
    confpath="$HOME/.config/$conf"
    if [ -e "$confpath" ]; then
      mv "$confpath" "$confpath.bak"
    fi
    ln -s "$dotdir/config/$conf" "$confpath"
  done
else
  echo "No $dotdir directory"
fi
