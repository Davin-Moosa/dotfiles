#!/usr/bin/env bash

# symlinks
dotdir="$HOME/dotfiles"
confs=(
  Proton
  fish
  git
  niri
  nvim
  waybar
  xdg-terminals.list
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

tldr -u

git clone https://aur.archlinux.org/yay.git "$HOME/.local/aur/yay"
cd "$HOME/.local/aur/yay"
makepkg -sri
yay -S helium-browser-bin nautilus-open-any-terminal neovim-nightly-bin

dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal custom
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal custom-local-command zellij
