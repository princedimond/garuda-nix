# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

let
  vars = import ./variables.nix;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Services configuration
    ./services.nix
    ./packages/virtualisation.nix
  ];


  # Boot/Kernel Options
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

/*
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use stable kernel for better Nvidia driver compatibility
  # Latest kernel (6.18) has API incompatibilities with current Nvidia drivers
  boot.kernelPackages = pkgs.linuxPackages_latest;
*/

  networking.hostName = vars.hostName; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.wireguard.enable = true;

  # Other Environment Configs
  environment.shellAliases = {
    fr = "nh os switch --hostname $hostname ~/garuda-nix/$hostname";
    fb = "nh os boot --hostname $hostname ~/garuda-nix/$hostname";
    fu = "nh os switch --hostname $hostname ~/garuda-nix/$hostname --update";
    fbu = "nh os boot --hostname $hostname ~/garuda-nix/$hostname --update";
    v = "nvim";
  };

  # Enable Flakes
  #nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable Flakes & Cleanup
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      #substituters = [ "https://hyprland.cachix.org" ];
      #trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Enable Garuda Desktop
  garuda = {
    dr460nized.enable = true;
    # gaming.enable = true;
    # chromium = true;
    # desktops.enable = true;
    # performance = true;
    performance-tweaks = {
      #cachyos-kernel = true;
      enable = true;
    };
  };

  /*
    dr460nixed = {
      chromium = true;
      desktops.enable = true;
      example-boot.enable = true;
      performance = true;
    };
  */

  # Programs as modules for extra options
  programs = {
    neovim.viAlias = true;
    neovim.vimAlias = true;
    steam = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };
  };

  # Set your time zone.
  time.timeZone = vars.timeZone;

  # Select internationalisation properties.
  i18n.defaultLocale = vars.locale;

  i18n.extraLocaleSettings = vars.localeSettings;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.${vars.userName} = {
    isNormalUser = true;
    description = vars.userName;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "podman"
      "input"
      "video"
      "seat"
      "japanese"
    ];
    packages =
      let
        systemPkgs = import (./packages/system.nix) { inherit pkgs inputs; };
      in
      systemPkgs.wine
      ++ (with pkgs; [
        thunderbird
        thunderbolt
      ]);
  };

  # NOTE: nixpkgs. config is now set in flake.nix when creating the pkgs instance
  # This is required when using the garuda.lib.garudaSystem with a custom pkgs

  # Import organized package lists
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    let
      systemPkgs = import (./packages/system.nix) { inherit pkgs inputs; };
      devPkgs = import (./packages/development.nix) { inherit pkgs inputs; };
    in
    # Flatten all package categories into a single list
    systemPkgs.core
    ++ systemPkgs.development
    ++ systemPkgs.productivity
    ++ systemPkgs.networking
    ++ systemPkgs.media
    ++ systemPkgs.utilities
    ++ systemPkgs.gaming
    ++ systemPkgs.printing
    ++ systemPkgs.browsers
    ++ systemPkgs.extras
    # Add development packages (uncomment categories you want to enable)
    ++ devPkgs.languages
    ++ devPkgs.editors
    ++ devPkgs.vcs
    ++
      # devPkgs.build ++
      # devPkgs.databases ++
      # devPkgs.containers ++
      [ ];

  # Note: Wine packages are handled separately in users.users.princedimond.packages

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Services are now configured in services.nix

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Home Manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    users.${vars.userName} = import ./home.nix;
    extraSpecialArgs = { inherit vars; };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
