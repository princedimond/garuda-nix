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
    microfetch
    btop
    htop
    glances
    mission-center
    apacheHttpd
    microsoft-edge
    tmux
    rpi-imager
    czkawka-full
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
    discordo
    thunderbird
    onlyoffice-desktopeditors
    joplin-desktop
    affine
    #anytype
    logseq
    evolution
  ];

  # VPN and networking
  networking = with pkgs; [
    protonvpn-gui
    expressvpn
    tailscale
    input-leap
    deskflow
    windterm
    nmap
    putty
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
    bitwarden-desktop
    xfce.thunar
    gnome-disk-utility
    system-config-printer
    flatpak
    teamviewer
    warp-terminal
    zed-editor
    remmina
    xrdp
    lynis
    chirp
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
  ];
}
