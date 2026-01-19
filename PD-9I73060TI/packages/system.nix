{
  pkgs,
  inputs,
  ...
}:

{
  # Core system utilities
  core = with pkgs; [
    wget
    curl
    filezilla
    windterm
    pciutils
    direnv
    fastfetch
    microfetch
    btop
    htop
    glances
    mission-center
    resources
    apacheHttpd
    rar
    nh
    cpu-x
    cosmic-ext-tweaks
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
    kdePackages.calligra
    libreoffice-qt-fresh
    freeplane
    dia
    yed
    affine
    anytype
    logseq
    joplin-desktop
    evolution
    quassel
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
    #freecad
    #freecad-wayland
    lunacy
    #obs-studio
    kdePackages.kdenlive
    krita
    davinci-resolve
    handbrake
    devede
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
    hollywood
    virtio-win
    win-spice
    czkawka-full
    xdg-desktop-portal
    xdg-desktop-portal-cosmic
  ];

  # Gaming
  gaming = with pkgs; [
    xivlauncher
    steam
    heroic
    umu-launcher
    nvidia-system-monitor-qt
    protonup-ng
    protonup-qt
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
    solaar
  ];

  #orca-slicer overlay
  orca-slicer-overlay = final: prev: {
    orca-slicer = prev.orca-slicer.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        mv $out/bin/orca-slicer $out/bin/.orca-slicer-wrapped
        echo "env __GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json MESA_LOADER_DRIVER_OVERRIDE=zink GALLIUM_DRIVER=zink WEBKIT_DISABLE_DMABUF_RENDERER=1 $out/bin/.orca-slicer-wrapped" > $out/bin/orca-slicer
        chmod +x $out/bin/orca-slicer
      '';
    });
  };

  # Programs as modules for extra options
  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };
  };
}
