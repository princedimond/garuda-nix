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
    rar
    microsoft-edge
    resources
    kdePackages.kdenetwork-filesharing
  ];

  # Development tools
  development = with pkgs; [
    #vscode
    gitkraken
    github-desktop
    gitnuro
    git-lfs
    meld
    nixd
    nil
    evil-helix
    nh
    onefetch
    lazygit
    gh
    glab
    github-copilot-cli
    anki
    inputs.nixvim.packages.x86_64-linux.default
  ];

  # Communication and productivity
  productivity = with pkgs; [
    ferdium
    discord
    thunderbird
    onlyoffice-desktopeditors
    affine
    #anytype
    #logseq
    evolution
    appflowy
    siyuan
  ];

  # VPN and networking
  networking = with pkgs; [
    #protonvpn-gui
    expressvpn
    tailscale
    remmina
    wireguard-ui
    wireguard-tools
    putty
    windterm
    winbox4
    filezilla
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
    thunar
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
    #hollywood
    virtio-win
    win-spice
    rpi-imager
    input-leap
    cockpit
    sscg
    taxi
    solaar
    logitech-udev-rules
    yazi
    #cockpit-files
    #cockpit-zfs
    #cockpit-podman
    #cockpit-machines
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
    #inputs.zen-browser.packages.x86_64-linux.specific
    #inputs.zen-browser.packages.x86_64-linux.generic
  ];

  # Additional tools with duplicates removed
  extras = with pkgs; [
    thunderbolt
    #open-webui
    lmstudio
  ];
}
