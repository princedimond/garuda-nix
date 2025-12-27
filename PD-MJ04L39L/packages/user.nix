{ pkgs, ... }:

{
  # User-specific development tools
  development = with pkgs; [
    # Add development tools that should be user-specific
    # Examples:
    # python3
    # nodejs
    # rustc
    # go
  ];

  # User utilities and personal tools
  utilities = with pkgs; [
    # Add user-specific utilities here
    # Examples:
    # neofetch
    # tree
    # fd
    # ripgrep
    # bat
  ];

  # User media and entertainment
  media = with pkgs; [
    # Add user media tools here
    # Examples:
    # mpv
    # spotify
    # vlc
  ];

  # User productivity tools
  productivity = with pkgs; [
    # Add personal productivity tools here
    # Examples:
    # obsidian
    # notion-app-enhanced
  ];

  # Shell and terminal enhancements
  shell = with pkgs; [
    # Add shell enhancements here
    # Examples:
    # starship
    # zoxide
    # fzf
  ];
}
