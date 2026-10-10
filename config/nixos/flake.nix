{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ ... }: {
    nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        (
          { pkgs, ... }:
          {
            nixpkgs.overlays = [
              inputs.nix-cachyos-kernel.overlays.default
              inputs.neovim-nightly-overlay.overlays.default
            ];

            nix.settings = {
              substituters = [ "https://attic.xuyh0120.win/lantian" ];
              trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
            };

            boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;

            environment.systemPackages = [
              inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
          }
        )
      ];
    };
  };
}
