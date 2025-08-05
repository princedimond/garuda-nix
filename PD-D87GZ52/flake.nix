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
    chaotic-nyx = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
   };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "chaotic-nyx/nixpkgs";
    };
   nixpkgs.follows = "chaotic-nyx/nixpkgs";
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
      chaotic-nyx,
      ...
    }:
    {
      nixosConfigurations = {
        PD-D87GZ52 = garuda.lib.garudaSystem {
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
