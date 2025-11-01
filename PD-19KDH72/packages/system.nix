{ pkgs, inputs, ... }:

{
  # Core system utilities
  core = with pkgs; [
    wget
    git
    curl
    pciutils
    direnv
    fastfetch
    btop
    htop
    glances
    mission-center
    apacheHttpd
    hollywood
  ];

  # Development tools
  development = with pkgs; [
    #vscode
    gitkraken
    github-desktop
    meld
    nixd
    nil
    #helix-gpt
    #evil-helix
    nh
    onefetch
    inputs.nixvim.packages.x86_64-linux.default
  ];

  # Communication and productivity
  productivity = with pkgs; [
    ferdium
    discord
    thunderbird
    onlyoffice-bin
    affine
    anytype
    logseq
    evolution
  ];

  # VPN and networking
  networking = with pkgs; [
    protonvpn-gui
    protonvpn-cli
    expressvpn
    tailscale
    input-leap
    deskflow
  ];

  # Media and graphics
  media = with pkgs; [
    deluge
    gthumb
    imagemagick
    graphicsmagick-imagemagick-compat
    orca-slicer
    lunacy
  ];

  # System utilities and file management
  utilities = with pkgs; [
    bitwarden
    xfce.thunar
    gnome-disk-utility
    system-config-printer
    flatpak
    teamviewer
    warp-terminal
    zed-editor
    remmina
    xrdp
    lsirec
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
    inputs.zen-browser.packages.x86_64-linux.specific
    inputs.zen-browser.packages.x86_64-linux.generic
  ];

  # Additional tools with duplicates removed
  extras = with pkgs; [
    thunderbolt
  ];
}
