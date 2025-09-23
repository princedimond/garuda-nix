# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-5cbbfd51-d1d4-4eaa-af02-223436145bf4".device =
    "/dev/disk/by-uuid/5cbbfd51-d1d4-4eaa-af02-223436145bf4";

  networking.hostName = "PD-19KDH72"; # Define your hostname.
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
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.princedimond = {
    isNormalUser = true;
    description = "princedimond";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      thunderbird
      thunderbolt
      wine
      wine64
      wine-wayland
    ];
  };

  # Nix packages config unfree/allowed insecure packages
  #nixpkgs.config.allowUnfree = true;
  nixpkgs.config = {
    allowUnFree = true;
    permittedInsecurePackages = [
      "libsoup-2.74.3"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    curl
    pciutils
    ferdium
    protonvpn-gui
    protonvpn-cli
    gitkraken
    github-desktop
    btop
    vscode
    bitwarden
    expressvpn
    onlyoffice-bin
    direnv
    #vlc
    deluge
    htop
    glances
    #pro-office-calculator
    mission-center
    pkgs.gnome-disk-utility
    orca-slicer
    fastfetch
    meld
    #node2nix
    nixd
    #helix
    helix-gpt
    nh
    apacheHttpd
    tailscale
    thunderbolt
    affine
    gthumb
    # kdePackages.gwenview
    evil-helix
    xfce.thunar
    hplipWithPlugin
    hplip
    system-config-printer
    imagemagick
    graphicsmagick-imagemagick-compat
    gthumb
    discord
    flatpak
    teamviewer
    warp-terminal
    zed-editor
    nil
    lunacy
    inputs.zen-browser.packages.x86_64-linux.default
    inputs.zen-browser.packages.x86_64-linux.specific
    inputs.zen-browser.packages.x86_64-linux.generic
    inputs.nixvim.packages.x86_64-linux.default
  ];

  # Git Options
  programs.git = {
    enable = true;
    # userName = "princedimond";
    # userEmail = "princedimond@gmail.com";
  };

  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak install -y microsoft-edge
    '';
  };

  services.flatpak.packages = [
    "com.microsoft.Edge"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.flatpak.enable = true;
  services.hardware.bolt.enable = true;
  services.expressvpn.enable = true;
  services.tailscale.enable = true;
  services.printing.enable = true; # enable CUPS to print documents
  services.teamviewer.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
