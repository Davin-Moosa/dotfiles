#!/usr/bin/env bash

# packages
pkgs=(
  anki
  bat
  eza
  fish
  fzf
  godot-mono
  keyd
  libreoffice-fresh-en-za
  proton-vpn-gtk-app
  ruff
  neovim-nightly-bin
  steam
  tealdeer
  tree-sitter-cli
  uv
  wl-clipboard
  zellij
  zoxide
)

sudo pacman -Syu --needed "${pkgs[@]}"

chsh -s /usr/bin/fish
sudo pkgfile -u
tldr -u

# symlinks
dotdir="$HOME/dotfiles"
confs=(
  Proton
  fish
  git
  nvim
  zellij
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
