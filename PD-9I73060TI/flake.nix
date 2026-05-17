{
  description = "Garuda-NIX";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:Nixos/nixpkgs/nixos-unstable";
    #nixpkgs-linux-zen_6_18_9.url = "github:Nixos/nixpkgs/80d901ec0377e19ac3f7bb8c035201e2e098cc97";
    garuda.url = "gitlab:garuda-linux/garuda-nix-subsystem/stable";
    nixvim.url = "github:dc-tec/nixvim";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    flake-utils.url = "github:numtide/flake-utils";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Star Citizen via nix-citizen https://github.com/LovingMelody/nix-citizen
    nix-citizen.url = "github:LovingMelody/nix-citizen";
    #Optional - updates underlying wihtout waiting for nix-citizen to update
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-citizen.inputs.nix-gaming.follows = "nix-gaming";
    

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
      flake-utils,
      agenix,
      nix-citizen,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";

      /*
        # overlay that wraps orca-slicer
        overlay = final: prev: {
          orca-slicer = prev.orca-slicer.overrideAttrs (old: {
            postInstall = (old.postInstall or "") + ''
              mv $out/bin/orca-slicer $out/bin/.orca-slicer-wrapped
              echo "env __GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json MESA_LOADER_DRIVER_OVERRIDE=zink GALLIUM_DRIVER=zink WEBKIT_DISABLE_DMABUF_RENDERER=1 $out/bin/.orca-slicer-wrapped" > $out/bin/orca-slicer
              chmod +x $out/bin/orca-slicer
            '';
          });
        };
      */

      pkgs = nixpkgs.legacyPackages.${system};
      /*
        pkgs = import nixpkgs {
          # nixpkgs.legacyPackages.${system};
          inherit system;
        };
      */

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
            agenix.nixosModules.default
            nix-citizen.nixosModules.default
            {
              #cachix setup
              nix.settings = {
                substituters = ["https://nix-citizen.cachix.org"];
                trusted-public-keys = ["nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="];
              };
              programs.rsi-launcher = {
                #enables star citizen module
                enable = true;
                # additional commands before the game starts
                preCommands = ''
                  export DXVK_HUD=compiler;
                  export MANGO_HUD=1;
                '';
              # # This option is enabled by default
              # #  Configures your system to meet some of the requirements to run star-citizen
              # # Set `vm.max_map_count` default to `16777216` (sysctl(8))
              # #Set `fs.file-max` default to `524288` (sysctl(8))
              # #Also sets `security.pam.loginLimits` to increase hard (limits.conf(5))
              # # Changes outlined in  https://github.com/starcitizen-lug/knowledge-base/wiki/Manual-Installation#prerequisites
              # setLimits = false;
              };
            }
            #home-manager.nixosModules.home-manager
            {
              #nixpkgs.overlays = [ overlay ];
              nixpkgs.config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "libsoup-2.74.3"
                  "electron-35.7.5"
                  "ventoy-1.1.12"
                  "ventoy-qt5-1.1.12"
                ];
              };
            }
            ./configuration.nix
          ];
        };
      };
    };
}
