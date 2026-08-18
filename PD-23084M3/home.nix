{
  config,
  pkgs,
  vars,
  inputs,
  ...
}:

{

  imports = [
    ./evil-helix.nix
    ./gtk.nix
    #inputs.catppuccin.homeModules.catppuccin
    #./home.nix
    #./japanese.nix
  ];
  home.username = "princedimond";
  home.homeDirectory = "/home/princedimond";
  #home.stateVersion = "25.11";
  home.pointerCursor.enable = true;
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "princedimond";
      user.email = "princedimond@gmail.com";
      credential.helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
  };

  # ─────────────────────────────────────────────
  # Niri Configuration Deployment
  # Deploys to: ~/.config/niri/
  # ─────────────────────────────────────────────
  xdg.configFile."niri/config.kdl".source = ./config.kdl;
  xdg.configFile."niri/noctalia.kdl".source = ./noctalia.kdl;

  # ─────────────────────────────────────────────
  # Noctalia Configuration Deployment
  # Deploys to: ~/.config/noctalia/
  # ─────────────────────────────────────────────
  xdg.configFile."noctalia/config.toml".source = ./noctalia-config.toml;

  # ─────────────────────────────────────────────
  # Wallpaper & Icon Files
  # Deployed to: ~/garuda-nix/PD-23084M3/Wallpapers/
  # Referenced by niri config.kdl and noctalia-config.toml
  # via ~/garuda-nix/PD-23084M3/Wallpapers/... paths
  # ─────────────────────────────────────────────
  home.file."garuda-nix/PD-23084M3/Wallpapers/Logo-transparant.png".source = ./Wallpapers/Logo-transparant.png;
  home.file."garuda-nix/PD-23084M3/Wallpapers/favicon.png".source = ./Wallpapers/favicon.png;

  # Catppuccin Config
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "green";
    cursors.enable = true;
    zed.enable = true;
    thunderbird.enable = true;
    nvim.enable = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  #enable catppuccin theme for these applications
  programs = {
    btop.enable = true;
    lazygit.enable = true;
    yazi.enable = true;
    television = {
      enable = true;
      enableBashIntegration = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
