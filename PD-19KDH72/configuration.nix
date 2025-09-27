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
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-5cbbfd51-d1d4-4eaa-af02-223436145bf4".device =
    "/dev/disk/by-uuid/5cbbfd51-d1d4-4eaa-af02-223436145bf4";

  networking.hostName = vars.hostName; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
      cachyos-kernel = true;
      enable = true;
    };
  };

  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;

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

  # Nix packages config unfree/allowed insecure packages
  #nixpkgs.config.allowUnfree = true;
  nixpkgs.config = {
    allowUnFree = true;
    permittedInsecurePackages = [
      "libsoup-2.74.3"
    ];
  };

  # Import organized package lists
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    let
      systemPkgs = import (./packages/system.nix) { inherit pkgs inputs; };
      devPkgs = import (./packages/development.nix) { inherit pkgs; };
    in
    # Flatten all package categories into a single list
    systemPkgs.core
    ++ systemPkgs.development
    ++ systemPkgs.productivity
    ++ systemPkgs.networking
    ++ systemPkgs.media
    ++ systemPkgs.utilities
    ++ systemPkgs.printing
    ++ systemPkgs.browsers
    ++ systemPkgs.extras
    ++
      # Add development packages (uncomment categories you want to enable)
      # devPkgs.languages ++
      # devPkgs.build ++
      # devPkgs.databases ++
      # devPkgs.containers ++
      [ ];

  # Note: Wine packages are handled separately in users.users.princedimond.packages

  # Git Options
  programs.git = {
    enable = true;
    # userName = "princedimond";
    # userEmail = "princedimond@gmail.com";
  };



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
