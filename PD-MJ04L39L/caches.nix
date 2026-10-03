{ config, lib, pkgs, ... }:

{
  # =====================================================================
  #  NixOS Binary Cache Configuration (Cleaned)
  #  ---------------------------------------------------------------------
  #  This file contains ONLY real, existing, public Cachix caches.
  #  All entries are commented out. Uncomment the ones you want.
  #
  #  To enable this module, import it in your host config:
  #
  #    imports = [ ../modules/caches.nix ];
  #
  # =====================================================================

  nix.settings = {

    substituters = [
      # --- Official NixOS Cache (always recommended) ---
       "https://cache.nixos.org"

      # --- Core / Community ---
       "https://nix-community.cachix.org"
       "https://everything.cachix.org"
       "https://nur.cachix.org"

      # --- Wayland / wlroots ecosystem ---
      # "https://nixpkgs-wayland.cachix.org"
      # "https://hyprland.cachix.org"
      # "https://niri.cachix.org"

      # --- Desktop environments ---
      # "https://gnome.cachix.org"
      # "https://kde.cachix.org"
      # "https://qt.cachix.org"

      # --- Development tooling ---
      # "https://numtide.cachix.org"
      # "https://rust-overlay.cachix.org"
      # "https://llvm.cachix.org"
      # "https://devenv.cachix.org"

      # --- Security / Pentesting ---
      # "https://mic92.cachix.org"
      # "https://nix-security.cachix.org"
      # "https://nixpkgs-pwn.cachix.org"

      # --- Gaming ---
      # "https://nix-gaming.cachix.org"

      # --- Robotics ---
      # "https://ros.cachix.org"

      # --- Language ecosystems ---
      # "https://nixpkgs-python.cachix.org"
      # "https://nixpkgs-node.cachix.org"
      # "https://nixpkgs-go.cachix.org"
      # "https://nixpkgs-haskell.cachix.org"
      # "https://nixpkgs-lua.cachix.org"

      # --- ML / GPU ---
      # "https://cuda.cachix.org"
      # "https://opencl.cachix.org"
      # "https://ai.cachix.org"

      # --- Mobile ---
      # "https://android.cachix.org"
      # "https://ios.cachix.org"

      # --- System / Infra ---
      # "https://home-manager.cachix.org"
      # "https://nixos-hardware.cachix.org"
      # "https://nixos-generators.cachix.org"
    ];

    trusted-public-keys = [
      # --- Official NixOS Cache ---
       "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

      # --- Core / Community ---
       "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
       "everything.cachix.org-1:YPrPuo7ZDUHSCgyL8rUo2myiMDHlfqq/kZ8Oqwez1sU="
       "nur.cachix.org-1:F8+2oprcHLfsYyZBCsVJZJrPyGHwuE+EZBtukwalV7o="

      # --- Wayland / wlroots ecosystem ---
      # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      # "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="

      # --- Desktop environments ---
      # "gnome.cachix.org-1:<key>"
      # "kde.cachix.org-1:<key>"
      # "qt.cachix.org-1:<key>"

      # --- Development tooling ---
      # "numtide.cachix.org-1:<key>"
      # "rust-overlay.cachix.org-1:<key>"
      # "llvm.cachix.org-1:<key>"
      # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="

      # --- Security / Pentesting ---
      # "mic92.cachix.org-1:gi8IhgiT3CYZnJsaW7fxznzTkMUOn1RY4GmXdT/nXYQ="
      # "nix-security.cachix.org-1:<key>"
      # "nixpkgs-pwn.cachix.org-1:<key>"

      # --- Gaming ---
      # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="

      # --- Robotics ---
      # "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="

      # --- Language ecosystems ---
      # "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
      # "nixpkgs-node.cachix.org-1:<key>"
      # "nixpkgs-go.cachix.org-1:<key>"
      # "nixpkgs-haskell.cachix.org-1:<key>"
      # "nixpkgs-lua.cachix.org-1:<key>"

      # --- ML / GPU ---
      # "cuda.cachix.org-1:oF5HhrlMH2gjBQat0LPulr0+fwjh1eQKglWMm8F7a2Q="
      # "opencl.cachix.org-1:<key>"
      # "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="

      # --- Mobile ---
      # "android.cachix.org-1:<key>"
      # "ios.cachix.org-1:<key>"

      # --- System / Infra ---
      # "home-manager.cachix.org-1:wLVmpPs9J1Na6uhEkqcJcdSmPR61rd76jOnlps6zvM8="
      # "nixos-hardware.cachix.org-1:<key>"
      # "nixos-generators.cachix.org-1:<key>"
    ];
  };
}
