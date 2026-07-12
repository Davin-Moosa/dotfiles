#!/usr/bin/bash

# install packages
pkgs=(
  # check for bin versions
  anki-bin
  bat
  blueman
  brave
  brightnessctl
  btop
  chafa
  eza
  fd
  fish
  fzf
  ghostty
  git
  gnome-keyring
  keyd
  libreoffice-bin
  linux-cachyos
  neovim-nightly
  pavucontrol
  polkit_gnome
  proton-vpn
  qt6ct
  ripgrep
  steam
  tealdeer
  tlp
  tlp-pd
  tlp-rdw
  fira-code
  nerd-fonts.symbols-only
  uv
  wl-clipboard
  wlsunset
  xwayland-satellite
  zoxide
)
sudo pacman -Syu --needed "${pkgs[@]}"

# dark mode
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"

# tldr
tldr -u

# user config
sudo usermod -aG uucp "$(whoami)"
sudo chsh -s /usr/bin/fish "$(whoami)"
sudo chfn -f "$(whoami | sed "s/./\u&/")" "$(whoami)"

# kernel
echo "options amd_pmc enable_stb=1" | sudo tee amd_pmc.conf >/dev/null
sudo sed -i "s/#default_\(uki\|options\)/default_\1/" /etc/mkinitcpio.d/linux-cachyos.preset
sudo sed -i "s/default_image/#default_image/" /etc/mkinitcpio.d/linux-cachyos.preset
sudo mkinitcpio -p linux-cachyos

# keyd
sudo tee /etc/keyd/default.conf >/dev/null << "EOF"
[ids]
*

[main]
capslock = overload(control, esc)
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
ln -sf "$(pwd)/.config/fish" ~/.config
ln -sf "$(pwd)/.config/fuzzel" ~/.config
ln -sf "$(pwd)/.config/ghostty" ~/.config
ln -sf "$(pwd)/.config/mako" ~/.config
ln -sf "$(pwd)/.config/niri" ~/.config
ln -sf "$(pwd)/.config/nvim" ~/.config
ln -sf "$(pwd)/.config/Proton" ~/.config
ln -sf "$(pwd)/.config/waybar" ~/.config
ln -sf "$(pwd)/.gitconfig" ~/
