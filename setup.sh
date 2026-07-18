#!/usr/bin/bash

# configure network connection
nmtui

# install packages
pkgs=(
  # check for bin versions
  anki
  bat
  blueman
  brave-origin-bin
  brightnessctl
  eza
  fd
  fish
  fzf
  ghostty-nautilus
  git
  gnome-keyring
  keyd
  lib32-vulkan-radeon
  libreoffice-fresh
  linux-cachyos
  man-db
  man-pages
  neovim-nightly-bin
  pavucontrol
  polkit-gnome
  proton-vpn-gtk-app
  qt6ct
  ripgrep
  steam
  sunsetr
  tealdeer
  texinfo
  tlp
  tlp-pd
  tlp-rdw
  tree-sitter-cli
  ttf-fira-code
  ttf-nerd-fonts-symbols
  uv
  wl-clipboard
  xwayland-satellite
  zoxide
)
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -Syu --needed "${pkgs[@]}"

# set dark theme for gtk4 apps
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
# check /usr/share/themes and /usr/share/local/themes to set dark mode for gtk3 apps

# tldr
tldr -u

# user config
sudo usermod -aG uucp "$(whoami)"
sudo chsh -s /usr/bin/fish "$(whoami)"
sudo chfn -f "$(whoami | sed "s/./\u&/")" "$(whoami)"

# kernel
# echo "options amd_pmc enable_stb=1" | sudo tee amd_pmc.conf >/dev/null
sudo sed -i "s/#default_\(uki\|options\)/default_\1/" /etc/mkinitcpio.d/linux-cachyos.preset
sudo sed -i "s/default_image/#default_image/" /etc/mkinitcpio.d/linux-cachyos.preset
sudo mkinitcpio -p linux-cachyos

# keyd
sudo tee /etc/keyd/default.conf >/dev/null << "EOF"
[ids]
*

[main]
capslock = overload(control, esc)
esc = capslock
EOF
sudo systemctl enable keyd --now

# tlp
sudo sed -i "s/#\(\w*\)_CHARGE_THRESH_BAT0/\1_CHARGE_THRESH_BAT0/" /etc/tlp.conf
sudo sed -i "s/STOP_CHARGE_THRESH_BAT0=80/STOP_CHARGE_THRESH_BAT0=1/" /etc/tlp.conf
sudo sed -i "s/#DEVICES_TO_\(\w*\)_ON_\(\w*\)_\(\w*\)CONNECT/DEVICES_TO_\1_ON_\2_\3CONNECT/" /etc/tlp.conf

# remove packages
rm=(htop vim alacritty nano linux)
sudo pacman -Rns "${rm[@]}"

# symlinks
dir="$HOME/dotfiles"
confs=(
  "Proton"
  "fish"
  "fuzzel"
  "ghostty"
  "git"
  "mako"
  "niri"
  "nvim"
  "qt6ct"
  "sunsetr"
  "waybar"
)
if [ -d "$dir" ] then
  for conf in "${confs[@]}"; do
    ln -sf "$dir/config/$conf" "$HOME/.config/"
  done
else
  echo "No $dir directory"
fi
