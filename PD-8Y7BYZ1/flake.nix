{
  description = "Garuda-NIX";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    garuda.url = "gitlab:garuda-linux/garuda-nix-subsystem/stable";
    nixvim.url = "github:dc-tec/nixvim";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      garuda,
      nixvim,
      home-manager,
      plasma-manager,
      zen-browser,
      nix-flatpak,
      ...
    }:
    {
      nixosConfigurations = {
        PD-8Y7BYZ1 = garuda.lib.garudaSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            nix-flatpak.nixosModules.nix-flatpak
            ./configuration.nix
          ];
        };
      };
    };
}
