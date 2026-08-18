{
  description = "Garuda-NIX";

  /*
    nixConfig.extra-substituters = [
      "https://nyx.chaotic.cx"
    ];

    nixConfig.extra-trusted-public-keys = [
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ];
  */

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    garuda.url = "gitlab:garuda-linux/garuda-nix-subsystem/stable";
    nixvim.url = "github:dc-tec/nixvim";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    /*
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    */
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    }; catppuccin = {
      url = "github:catppuccin/nix";
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
      nixos-hardware,
      catppuccin,
      noctalia,
      niri,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      vars = import ./variables.nix;
    in
    {
      nixosConfigurations = {
        ${vars.hostName} = garuda.lib.garudaSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            nix-flatpak.nixosModules.nix-flatpak
            nixos-hardware.nixosModules.dell-latitude-7420
            ./configuration.nix
            #home-manager.nixosModules.home-manager
            inputs.niri.nixosModules.niri
            inputs.noctalia.nixosModules.default
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = false;
                  users.${vars.userName} = {
                    imports = [
                     ./home.nix
                    inputs.catppuccin.homeModules.catppuccin
                    ];
                  };
                  extraSpecialArgs = { inherit vars inputs; };
                #backupFileExtension = "backup";
                };
              }
            /*
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.princedimond = {
                  imports = [
                    ./home.nix
                    #cosmic-manager.homeManagerModules.cosmic-manager
                    inputs.catppuccin.homeModules.catppuccin
                  ];
                };
                backupFileExtension = "backup";
              };
            }
            */
          ];
        };
      };
    };
}
