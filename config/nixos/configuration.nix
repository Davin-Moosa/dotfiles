{ config, pkgs, ... }:

{
  # Include the results of the hardware scan.
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    # Define hostname.
    hostName = "nixos";

    # Configure network connections interactively.
    networkmanager.enable = true;
  };

  # Enable and configure bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_ZA.UTF-8";

  # Configure keymap in X11.
  services.xserver.xkb.layout = "us";

  # Define a user account.
  users.users."davin" = {
    isNormalUser = true;
    description = "Davin";
    extraGroups = [ "dialout" "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and nix commands.
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # wget
    anki
    bat
    eza
    fd
    fzf
    gcc
    git
    godot
    gdscript-formatter
    krita
    libreoffice
    proton-vpn
    pyrefly
    ripgrep
    ruff
    rumdl
    tealdeer
    tree-sitter
    uv
    zoxide
  ];

  environment.sessionVariables = {
    PROTON_ENABLE_WAYLAND = "1";
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    qrca
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

  # List programs that you want to enable:
  programs = {
    fish.enable = true;
    neovim.enable = true;
    nix-ld.enable = true;
    steam.enable = true;
  };

  # List services that you want to enable:
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable Plasma
    desktopManager.plasma6.enable = true;

    # Default display manager for Plasma
    displayManager.plasma-login-manager.enable = true;

    flatpak.enable = true;

    keyd = {
      enable = true;
      keyboards.default.settings = {
        main = {
          capslock = "esc";
          esc = "capslock";
        };
      };
    };

    # Printing
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
