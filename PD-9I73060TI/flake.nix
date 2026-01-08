{
  description = "Garuda-NIX";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
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
            #home-manager.nixosModules.home-manager
            {
              #nixpkgs.overlays = [ overlay ];
              nixpkgs.config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "libsoup-2.74.3"
                  "electron-35.7.5"
                ];
              };
            }
            ./configuration.nix
          ];
        };
      };
    };
}
