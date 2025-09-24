{
  description = "Garuda-NIX";

  nixConfig.extra-substituters = [
    "https://nyx.chaotic.cx"
  ];

   nixConfig.extra-trusted-public-keys = [
     "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
     "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
   ];

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
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        PD-19KDH72 = garuda.lib.garudaSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            ./configuration.nix
          ];
        };
      };
    };
}
