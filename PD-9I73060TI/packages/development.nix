{ pkgs, inputs, ... }:

{
  # Programming languages and runtimes
  languages = with pkgs; [
    # Uncomment and add languages you need
    # python3
    # python311Packages.pip
    # nodejs
    # nodePackages.npm
    # rustc
    # cargo
    # go
    # gcc
    # openjdk
    # dotnet-sdk
    # php
    # ruby
    nixd
    nil
  ];

  # Development tools and IDEs (with inputs)
  editors = with pkgs; [
    # These are already in system.nix but you can move them here if preferred:
    evil-helix
    helix-gpt
    zed-editor
    vscode
    meld
    inputs.nixvim.packages.x86_64-linux.default
  ];

  # Version control and collaboration
  vcs = with pkgs; [
    git
    gitui
    gitkraken
    github-desktop
    gitnuro
    git-lfs
    gh
    lazygit
  ];

  # Build tools and package managers
  build = with pkgs; [
    # cmake
    # gnumake
    # pkg-config
    # autoconf
    # automake
    # libtool
  ];

  # Database tools
  databases = with pkgs; [
    # sqlite
    # postgresql
    # mysql80
    # redis
    # mongodb
  ];

  # Container and virtualization tools
  containers = with pkgs; [
    # docker
    # docker-compose
    # podman
    # qemu
    # virtualbox
  ];
  # API testing and development
  api = with pkgs; [
    # postman
    # insomnia
    # curl # already in system
    # httpie
  ];

  # Documentation and notes
  docs = with pkgs; [
    # pandoc
    # texlive.combined.scheme-medium
    # mdbook
  ];
}
