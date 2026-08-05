{ config, lib, pkgs, inputs, ... }:

let
  # =====================================================================
  #  Cache Mapping Table
  #  ---------------------------------------------------------------------
  #  Maps package names or flake inputs to the caches they need.
  #  Extend this as your system grows.
  # =====================================================================

  cacheMap = {
    # Wayland / wlroots ecosystem
    hyprland = [ "hyprland" "nixpkgs-wayland" ];
    niri = [ "niri" "nixpkgs-wayland" ];
    sway = [ "nixpkgs-wayland" ];

    # Desktop environments
    plasma = [ "kde" ];
    gnome = [ "gnome" ];

    # Dev tooling
    rustc = [ "rust-overlay" ];
    cargo = [ "rust-overlay" ];
    clang = [ "llvm" ];
    clang-tools = [ "llvm" ];
    devshell = [ "numtide" ];
    treefmt = [ "numtide" ];

    # Security / pentesting
    pwntools = [ "nixpkgs-pwn" ];
    gdb = [ "mic92" ];

    # Gaming
    steam = [ "nix-gaming" ];
    lutris = [ "nix-gaming" ];

    # Robotics
    ros = [ "ros" ];

    # Language ecosystems
    python3 = [ "nixpkgs-python" ];
    nodejs = [ "nixpkgs-node" ];
    go = [ "nixpkgs-go" ];
    haskell = [ "nixpkgs-haskell" ];
    lua = [ "nixpkgs-lua" ];

    # ML / GPU
    cuda = [ "cuda" ];
    opencl = [ "opencl" ];
    ai = [ "ai" ];
  };

  # =====================================================================
  #  Cache Definitions (URLs only — keys filled in manually later)
  # =====================================================================

  cacheDefs = {
    "nix-community" = { url = "https://nix-community.cachix.org"; };
    "everything" = { url = "https://everything.cachix.org"; };
    "nur" = { url = "https://nur.cachix.org"; };

    "nixpkgs-wayland" = { url = "https://nixpkgs-wayland.cachix.org"; };
    "hyprland" = { url = "https://hyprland.cachix.org"; };
    "niri" = { url = "https://niri.cachix.org"; };

    "gnome" = { url = "https://gnome.cachix.org"; };
    "kde" = { url = "https://kde.cachix.org"; };
    "qt" = { url = "https://qt.cachix.org"; };

    "numtide" = { url = "https://numtide.cachix.org"; };
    "rust-overlay" = { url = "https://rust-overlay.cachix.org"; };
    "llvm" = { url = "https://llvm.cachix.org"; };
    "devenv" = { url = "https://devenv.cachix.org"; };

    "mic92" = { url = "https://mic92.cachix.org"; };
    "nix-security" = { url = "https://nix-security.cachix.org"; };
    "nixpkgs-pwn" = { url = "https://nixpkgs-pwn.cachix.org"; };

    "nix-gaming" = { url = "https://nix-gaming.cachix.org"; };

    "ros" = { url = "https://ros.cachix.org"; };

    "nixpkgs-python" = { url = "https://nixpkgs-python.cachix.org"; };
    "nixpkgs-node" = { url = "https://nixpkgs-node.cachix.org"; };
    "nixpkgs-go" = { url = "https://nixpkgs-go.cachix.org"; };
    "nixpkgs-haskell" = { url = "https://nixpkgs-haskell.cachix.org"; };
    "nixpkgs-lua" = { url = "https://nixpkgs-lua.cachix.org"; };

    "cuda" = { url = "https://cuda.cachix.org"; };
    "opencl" = { url = "https://opencl.cachix.org"; };
    "ai" = { url = "https://ai.cachix.org"; };

    "android" = { url = "https://android.cachix.org"; };
    "ios" = { url = "https://ios.cachix.org"; };

    "home-manager" = { url = "https://home-manager.cachix.org"; };
    "nixos-hardware" = { url = "https://nixos-hardware.cachix.org"; };
    "nixos-generators" = { url = "https://nixos-generators.cachix.org"; };
  };

  # =====================================================================
  #  Detection Logic
  # =====================================================================

  installedPkgs =
    builtins.map (p: p.pname or p.name)
      config.environment.systemPackages;

  flakeInputs = builtins.attrNames inputs;

  allSignals = installedPkgs ++ flakeInputs;

  neededCaches =
    lib.unique (
      lib.flatten (
        builtins.concatMap
          (pkg: cacheMap.${pkg} or [])
          allSignals
      )
    );

  resolvedCaches =
    builtins.filter (c: cacheDefs ? ${c}) neededCaches;

  urls = map (c: cacheDefs.${c}.url) resolvedCaches;

in
{
  # =====================================================================
  #  Verbose Logging (Option B2)
  # =====================================================================

  system.activationScripts.cacheDetect = {
    text = ''
      echo "[cache-detect] scanning system packages and flake inputs..."
      ${lib.concatStringsSep "\n" (map (c: ''
        echo "[cache-detect] enabling cache: ${cacheDefs.${c}.url}"
      '') resolvedCaches)}
    '';
  };

  # =====================================================================
  #  Merge with manual caches (Option M1)
  # =====================================================================

  nix.settings.substituters = lib.mkAfter urls;

  # Keys are not auto-filled — you will add them manually in caches.nix
}
