{ pkgs, inputs, ... }:

{
  # Core system utilities
  core = with pkgs; [
    wget
    curl
    pciutils
    direnv
    fastfetch
    btop
    htop
    glances
    mission-center
    apacheHttpd
    rar
    nh
  ];
  # Development tools
  development = with pkgs; [
    /*
      git # git is already in system packages
      gitui
      gh # GitHub CLI
      onefetch
      gitkraken
      github-desktop
      gitnuro
      git-lfs
      vscode
      evil-helix
      helix-gpt
      meld
      zed-editor
      inputs.nixvim.packages.x86_64-linux.default
      nixd
      nil
    */
  ];
  # Communication and productivity
  productivity = with pkgs; [
    ferdium
    discord
    thunderbird
    onlyoffice-desktopeditors
    affine
    anytype
    logseq
    evolution
  ];

  # VPN and networking
  networking = with pkgs; [
    #protonvpn-gui
    microsoft-edge
    expressvpn
    tailscale
    remmina
    wireguard-ui
    wireguard-tools
    deluge
    winbox4
  ];

  # Media and graphics
  media = with pkgs; [
    gthumb
    imagemagick
    graphicsmagick-imagemagick-compat
    orca-slicer
    lunacy
    obs-studio
  ];

  # System utilities and file management
  utilities = with pkgs; [
    bitwarden-desktop
    xfce.thunar
    gnome-disk-utility
    system-config-printer
    flatpak
    teamviewer
    warp-terminal
    zed-editor
    #virt-manager
    virt-viewer
    spice-gtk
    spice-protocol
    hollywood
    virtio-win
    win-spice
  ];

  # Gaming
  gaming = with pkgs; [
    xivlauncher
    steam
    heroic
    umu-launcher
  ];

  # Printing support
  printing = with pkgs; [
    hplipWithPlugin
    hplip
  ];

  # Wine compatibility layer
  wine = with pkgs; [
    wine
    wine64
    wine-wayland
  ];

  # Browsers (from inputs)
  browsers = [
    inputs.zen-browser.packages.x86_64-linux.default
  ];

  # Additional tools with duplicates removed
  extras = with pkgs; [
    thunderbolt
    open-webui
    lmstudio
  ];
}
