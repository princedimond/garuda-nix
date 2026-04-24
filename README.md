# 🐉 Garuda-Nix: Declarative NixOS Configuration

> **A reproducible, modular NixOS system configuration** based on Garuda Linux with Nix Flakes support for multi-system deployment and management.

---

## 📋 Table of Contents

- [✨ Overview](#-overview)
- [🏗️ Architecture & Structure](#️-architecture--structure)
- [🚀 Quick Start](#-quick-start)
- [📦 Deployment Configurations](#-deployment-configurations)
- [🔧 Configuration Guide](#-configuration-guide)
- [📚 Module Reference](#-module-reference)
- [🎯 Common Tasks](#-common-tasks)
- [🐛 Troubleshooting](#-troubleshooting)
- [📖 Advanced Topics](#-advanced-topics)

---

## ✨ Overview

**garuda-nix** is a declarative NixOS configuration framework built on top of [Garuda Linux](https://garudalinux.org/) and [Garuda-Nix-Subsystem](https://gitlab.com/garuda-linux/garuda-nix-subsystem). It provides:

- ✅ **Reproducible Builds**: Identical system configurations across multiple machines
- ✅ **Modular Design**: Separated concerns (hardware, services, packages, user config)
- ✅ **Multi-Deployment**: Support for multiple system configurations (PD-* directories)
- ✅ **Declarative Management**: Infrastructure-as-code for your entire system
- ✅ **Home Manager Integration**: User-level dotfiles and environment management
- ✅ **Flake Support**: Modern Nix with pinned dependencies and reproducibility
- ✅ **Theming**: Catppuccin integration for consistent, beautiful aesthetics

### Key Statistics

- **Language**: 100% Nix
- **License**: GPL-3.0
- **Total Deployments**: 8 active system configurations
- **Primary Package Sets**: 30+ organized categories

---

## 🏗️ Architecture & Structure

### Directory Hierarchy

```
garuda-nix/
├── README.md                          # This file
├── LICENSE                            # GPL-3.0 License
├── flake.nix                          # Root flake configuration (not present in root)
├── WARP.md                            # Additional documentation
│
├── PD-19KDH72/                        # Deployment #1
│   ├── flake.nix                      # Deployment-specific Nix Flake
│   ├── configuration.nix              # Main NixOS system configuration
│   ├── hardware-configuration.nix     # Hardware-specific settings (auto-generated)
│   ├── home.nix                       # Home Manager user environment
│   ├── variables.nix                  # 🔑 Central customization hub
│   ├── services.nix                   # System services & daemons
│   └── packages/
│       ├── system.nix                 # System-wide packages
│       ├── user.nix                   # User-specific packages
│       ├── development.nix            # Development tools & IDEs
│       ├── virtualisation.nix         # Container & VM tooling
│       └── README.md                  # Package management guide
│
├── PD-23084M3/                        # Deployment #2
│   └── [same structure as above]
│
├── PD-5CD8472PP3/                     # Deployment #3
├── PD-5CG9235MQ9/                     # Deployment #4
├── PD-9I73060TI/                      # Deployment #5
├── PD-BRFMF72/                        # Deployment #6
├── PD-GG8QRF2/                        # Deployment #7
├── PD-MJ04L39L/                       # Deployment #8
│
└── .github/                           # GitHub configuration
    └── [workflows, templates, etc.]
```

### Core Components

#### 1. **Flake System** (`*/flake.nix`)
The Flake is the entry point for NixOS configurations. Each deployment has its own flake that:
- Pins all dependencies to specific versions
- Defines Nix inputs (nixpkgs, home-manager, plasma-manager, etc.)
- Creates the `nixosConfigurations` output with the system name
- Manages special arguments passed to modules

**Key inputs used**:
- `nixpkgs` (25.11 or unstable): The official Nix package repository
- `garuda`: Garuda Linux's specialized module system
- `home-manager`: User configuration management
- `plasma-manager`: Plasma Desktop theming
- `zen-browser`: Privacy-focused browser
- `nix-flatpak`: Flatpak package integration

#### 2. **Variables Hub** (`variables.nix`) 🔑
The **central customization point** for each deployment:

```nix
{
  hostName = "PD-19KDH72";              # System hostname
  userName = "princedimond";             # Primary user
  timeZone = "America/Chicago";          # System timezone
  locale = "en_US.UTF-8";                # Default locale
  
  keyboard = {
    layout = "us";                       # Keyboard layout (us, de, fr, etc.)
    additionalLayouts = [ ];             # Multiple layout support
    variant = "";                        # Layout variant (empty for standard)
    options = [ ];                       # XKB options (e.g., grp:alt_shift_toggle)
  };
  
  homeDirectory = "/home/princedimond"; # User home path
  localeSettings = { /* ... */ };       # Fine-grained locale configuration
}
```

**When to use**: Modify this file for deployment-specific customization. All other files import and reference these variables.

#### 3. **Configuration** (`configuration.nix`)
The main NixOS configuration file that orchestrates:
- Hardware setup (LUKS encryption, kernel selection)
- System services and packages
- User accounts and permissions
- Nix settings and store optimization
- Garuda-specific features
- Package imports

**Key features**:
```nix
# Imports
imports = [
  ./hardware-configuration.nix  # Hardware-specific
  ./services.nix               # Service configuration
];

# Example: Custom aliases
environment.shellAliases = {
  fr = "nh os switch --hostname $hostname ~/garuda-nix/$hostname";
  fu = "nh os switch --hostname $hostname ~/garuda-nix/$hostname --update";
  v = "nvim";
};

# Garuda features
garuda = {
  dr460nized.enable = true;           # Garuda desktop
  performance-tweaks.enable = true;   # Performance optimizations
};
```

#### 4. **Services** (`services.nix`)
Manages system services and daemons:
- X11/Wayland keyboard configuration
- Flatpak integration
- VPN services (ExpressVPN, Tailscale)
- Printing (CUPS)
- Remote access (TeamViewer, OpenSSH)
- Input device handling

```nix
services = {
  xserver.xkb = {
    layout = vars.keyboard.layout;
    variant = vars.keyboard.variant;
  };
  flatpak.enable = true;
  expressvpn.enable = true;
  tailscale.enable = true;
  printing.enable = true;
};
```

#### 5. **Home Manager** (`home.nix`)
User-level configuration for:
- Theme settings (Catppuccin theming system)
- User packages and applications
- Dotfiles and configuration files
- Environment variables
- Shell customizations

```nix
catppuccin = {
  enable = true;
  flavor = "mocha";    # latte, frappe, macchiato, mocha
  accent = "mauve";    # Color accent choice
};
```

#### 6. **Packages** (`packages/`)
Organized package definitions split into logical categories:

**`system.nix`** - System-wide packages
- `core`: Essential utilities (wget, git, curl)
- `development`: IDEs and development tools
- `productivity`: Communication apps (Discord, Thunderbird)
- `networking`: VPN and networking tools
- `media`: Graphics and media editors
- `utilities`: File managers and system tools
- `printing`: Printer-related packages
- `wine`: Windows compatibility
- `browsers`: Browser packages
- `extras`: Additional tools

**`user.nix`** - User-specific packages
- `development`: User development tools
- `utilities`: Personal utilities
- `media`: Entertainment and media
- `productivity`: Productivity applications
- `shell`: Shell enhancements

**`development.nix`** - Development-focused packages
- `languages`: Programming languages and runtimes
- `editors`: Text editors and IDEs
- `vcs`: Version control systems
- `build`: Build tools and package managers
- `databases`: Database tools
- `containers`: Docker, Podman, Nix
- `api`: API testing tools
- `docs`: Documentation generators

---

## 🚀 Quick Start

### Prerequisites

- **NixOS** 25.11 or later installed on your system
- **Git** for version control
- **Nix Flakes** enabled in your Nix configuration

### Enable Nix Flakes (if not already enabled)

Edit `/etc/nixos/configuration.nix`:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Then rebuild:
```bash
sudo nixos-rebuild switch
```

### Clone and Deploy

```bash
# Clone the repository
git clone https://github.com/princedimond/garuda-nix.git
cd garuda-nix

# List available deployments
nix flake show

# Switch to a deployment (replace HOSTNAME with your target)
cd PD-19KDH72
sudo nixos-rebuild switch --flake .#PD-19KDH72
```

### Verify Installation

```bash
# Check current NixOS generation
nixos-rebuild list-generations

# Test configuration without switching
sudo nixos-rebuild test --flake .#PD-19KDH72

# View current system configuration
nix eval --json .#nixosConfigurations.PD-19KDH72.config.system.build.toplevel
```

---

## 📦 Deployment Configurations

This repository contains **8 independent system configurations**, each optimized for different use cases:

### Active Deployments

| Deployment | Status | Purpose | Branch |
|-----------|--------|---------|--------|
| **PD-19KDH72** | ✅ Active | Primary development machine | main |
| **PD-23084M3** | ✅ Active | Secondary system (nixpkgs-unstable) | main |
| **PD-5CD8472PP3** | ✅ Active | Unstable channel config | main |
| **PD-5CG9235MQ9** | ✅ Available | Additional deployment | main |
| **PD-9I73060TI** | ✅ Available | Additional deployment | main |
| **PD-BRFMF72** | ✅ Available | Additional deployment | main |
| **PD-GG8QRF2** | ✅ Available | Additional deployment | main |
| **PD-MJ04L39L** | ✅ Available | Additional deployment | main |

### Differences Between Deployments

**Nixpkgs Channel**:
- **PD-19KDH72**: `nixos-25.11` (stable)
- **PD-23084M3**: `nixpkgs-unstable` (latest)
- **PD-5CD8472PP3**: `nixpkgs-unstable` (latest)

**Kernel**:
- Most use latest kernel, but specific deployments may lock to version 6.18 for driver compatibility

**Services**:
- All support Flatpak, VPN, printing, and remote access
- Service variations based on hardware capabilities

---

## 🔧 Configuration Guide

### 1. Customizing Deployment Variables

Each deployment is configured through its `variables.nix`. To customize:

```bash
cd PD-19KDH72
nano variables.nix
```

**Editable fields**:
```nix
hostName = "MY-HOSTNAME";           # System name
userName = "myusername";            # Default user
timeZone = "America/Los_Angeles";   # Your timezone
locale = "en_US.UTF-8";             # Locale
keyboard = {
  layout = "us";                    # us, de, fr, etc.
  additionalLayouts = ["de"];       # Multi-layout support
  options = ["grp:alt_shift_toggle"]; # Switch with Alt+Shift
};
```

### 2. Adding System Packages

**Add to `packages/system.nix`**:
```nix
{
  pkgs,
  inputs,
}:
{
  utilities = with pkgs; [
    # Add your package here
    htop
    neofetch
    # new-package
  ];
}
```

**Then enable in `configuration.nix`**:
```nix
environment.systemPackages =
  let
    systemPkgs = import (./packages/system.nix) { inherit pkgs inputs; };
  in
  systemPkgs.utilities ++  # Now included in system
  [ ];
```

### 3. Adding User Packages

**Add to `packages/user.nix`**:
```nix
utilities = with pkgs; [
  # new-package
];
```

**Then enable in `home.nix`**:
```nix
home.packages =
  let
    userPkgs = import (./packages/user.nix) { inherit pkgs; };
  in
  userPkgs.utilities ++  # Uncomment to enable
  [ ];
```

### 4. Configuring Services

Edit `services.nix` to enable/disable services:

```nix
services = {
  flatpak.enable = true;         # Enable Flatpak
  printing.enable = true;        # Enable printing
  expressvpn.enable = false;     # Disable ExpressVPN
  tailscale.enable = true;       # Enable Tailscale
  xrdp.enable = true;            # Enable remote desktop
};
```

### 5. Theme Customization (Catppuccin)

Edit `home.nix`:
```nix
catppuccin = {
  enable = true;
  flavor = "mocha";    # Options: latte, frappe, macchiato, mocha
  accent = "mauve";    # Options: rosewater, flamingo, pink, mauve, red, maroon,
                       # peach, yellow, green, teal, sky, sapphire, blue, lavender
};
```

---

## 📚 Module Reference

### Hardware Configuration

**`hardware-configuration.nix`** (auto-generated, don't edit directly)
```bash
# Regenerate if hardware changes
sudo nixos-generate-config --root /mnt
# Then copy the hardware-configuration.nix
```

This file contains:
- File system mounts and UUIDs
- Bootloader configuration
- CPU-specific settings
- Kernel module loading
- Device-specific hardware features

### Garuda Features

Enabled via `configuration.nix`:
```nix
garuda = {
  dr460nized.enable = true;              # Enable Garuda desktop
  gaming.enable = false;                 # Gaming optimizations
  chromium = false;                      # Chromium browser
  desktops.enable = false;               # Additional desktops
  performance = false;                   # Performance tweaks
  performance-tweaks.enable = true;      # System optimization
};
```

### Key System Settings

```nix
# Bootloader
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

# Kernel
boot.kernelPackages = pkgs.linuxPackages_latest;

# Disk encryption (LUKS)
boot.initrd.luks.devices."luks-UUID".device = "/dev/disk/by-uuid/UUID";

# Networking
networking.networkmanager.enable = true;

# Nix settings
nix.settings.auto-optimise-store = true;
nix.gc.automatic = true;  # Weekly garbage collection
```

---

## 🎯 Common Tasks

### Building and Switching

```bash
# Full switch (rebuild + activate)
sudo nixos-rebuild switch --flake .#PD-19KDH72

# Update flake inputs first
nix flake update
sudo nixos-rebuild switch --flake .#PD-19KDH72

# Test without activating
sudo nixos-rebuild test --flake .#PD-19KDH72

# Build without switching
sudo nixos-rebuild build --flake .#PD-19KDH72

# Show what will change
sudo nixos-rebuild diff-closures --flake .#PD-19KDH72
```

### Using Custom Shell Aliases

Pre-configured shortcuts in `configuration.nix`:
```bash
# Quick rebuild
fr

# Rebuild with flake update
fu

# Open Neovim
v
```

### Managing Generations

```bash
# List all generations
nixos-rebuild list-generations

# Boot into previous generation
# (Select at GRUB menu on next reboot)

# Delete old generations
sudo nix-collect-garbage -d

# Delete generations older than 7 days
sudo nix-collect-garbage --delete-older-than 7d
```

### Updating Flake Inputs

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake update nixpkgs

# Check for updates without applying
nix flake update --dry-run

# Lock to specific commit
# Edit flake.nix, then:
nix flake update
```

### Checking Configuration Validity

```bash
# Validate flake syntax
nix flake check

# Evaluate specific option
nix eval .#nixosConfigurations.PD-19KDH72.config.services.flatpak.enable

# Show full configuration
nix eval --json .#nixosConfigurations.PD-19KDH72.config | jq .
```

---

## 🐛 Troubleshooting

### Issue: "Flakes not enabled"

**Error**: `experimental feature 'nix-command' is disabled`

**Solution**:
1. Edit `/etc/nixos/configuration.nix`:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
2. Rebuild: `sudo nixos-rebuild switch`
3. Retry the flake command

### Issue: Package Build Failure

**Problem**: `error: Package 'some-package' does not exist`

**Solution**:
1. Check package availability: `nix search nixpkgs some-package`
2. Update nixpkgs: `nix flake update nixpkgs`
3. Verify package name in Nix manual: https://search.nixos.org/packages
4. Remove from packages list if no longer available

### Issue: Service Won't Start

**Problem**: Service fails to enable or start

**Solution**:
1. Check service status: `systemctl status service-name`
2. View logs: `journalctl -u service-name -n 50`
3. Verify configuration: `nix eval .#nixosConfigurations.PD-19KDH72.config.services.service-name`
4. Disable conflicting services
5. Check GitHub issues for known incompatibilities

### Issue: Hardware Not Detected

**Problem**: Keyboard, mouse, or other devices not working

**Solution**:
1. Regenerate hardware config:
```bash
sudo nixos-generate-config --root /mnt
cp /etc/nixos/hardware-configuration.nix /mnt/hardware-configuration.nix
```
2. Ensure services are enabled:
   - `services.libinput.enable = true` (for keyboard/mouse)
   - `services.hardware.bolt.enable = true` (for Thunderbolt)
3. Load required kernel modules in `hardware-configuration.nix`

### Issue: Disk Space Running Low

**Problem**: Nix store consuming too much space

**Solution**:
1. Clean old generations:
```bash
sudo nix-collect-garbage -d
```

2. Remove old build artifacts:
```bash
nix-store --gc
```

3. Enable automatic garbage collection (already enabled):
```nix
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};
```

### Issue: Encryption Passphrase Not Working

**Problem**: LUKS decryption fails at boot

**Solution**:
1. Verify LUKS device UUID in `configuration.nix`
2. Check `/etc/crypttab`: `sudo cat /etc/crypttab`
3. Reset passphrase if needed (requires live USB)
4. Verify hardware configuration after updates

---

## 📖 Advanced Topics

### Creating a New Deployment

To create a new deployment (e.g., `PD-NEWHOST`):

```bash
# Copy existing deployment
cp -r PD-19KDH72 PD-NEWHOST
cd PD-NEWHOST

# Edit variables for new system
nano variables.nix
# Change: hostName, userName, timeZone, keyboard, etc.

# Generate hardware config on target machine
sudo nixos-generate-config --root /mnt
# Copy the generated hardware-configuration.nix

# Test the flake
nix flake check

# Build and switch
sudo nixos-rebuild switch --flake .#PD-NEWHOST
```

### Multi-Layout Keyboard Support

To enable keyboard layout switching:

Edit `variables.nix`:
```nix
keyboard = {
  layout = "us";
  additionalLayouts = ["de"];           # German layout
  options = ["grp:alt_shift_toggle"];   # Switch with Alt+Shift
};
```

**Common layout combinations**:
- `["us", "de"]` - US/German (Alt+Shift to switch)
- `["us", "de", "fr"]` - US/German/French
- Options: `grp:alt_shift_toggle`, `grp:caps_toggle`, `grp:shifts_toggle`

### Kernel Selection and Pinning

**Use latest kernel**:
```nix
boot.kernelPackages = pkgs.linuxPackages_latest;
```

**Pin to specific version**:
```nix
boot.kernelPackages = pkgs.linuxPackages_6_9;
```

**CachyOS kernel** (optimized):
```nix
boot.kernelPackages = pkgs.linuxPackages_cachyos;
```

### Insecure Package Handling

Some packages are marked insecure but still needed:
```nix
nixpkgs.config.permittedInsecurePackages = [
  "libsoup-2.74.3"
  "electron-35.7.5"
];
```

**Use cautiously** - Only include packages you truly need.

### Custom Nix Overlays

Create `overlays/default.nix` for custom packages:
```nix
final: prev: {
  my-custom-package = prev.stdenv.mkDerivation {
    # package definition
  };
}
```

Then import in `flake.nix`:
```nix
inputs.nixpkgs.overlays = [
  (import ./overlays)
];
```

### Integration with nix-direnv

For development environments, create `.envrc`:
```bash
use flake
```

Then install nix-direnv and direnv:
```bash
nix-shell -p direnv nix-direnv
direnv allow
```

---

## 🔗 Resources

- **Official Documentation**
  - [NixOS Manual](https://nixos.org/manual/nixos/stable/)
  - [Home Manager Manual](https://nix-community.github.io/home-manager/)
  - [Nix Flakes Guide](https://nixos.wiki/wiki/Flakes)

- **Related Projects**
  - [Garuda Linux](https://garudalinux.org/)
  - [Garuda Nix Subsystem](https://gitlab.com/garuda-linux/garuda-nix-subsystem)
  - [Plasma Manager](https://github.com/nix-community/plasma-manager)
  - [Catppuccin](https://catppuccin.com/)

- **Community**
  - [NixOS Discourse](https://discourse.nixos.org/)
  - [NixOS Discord](https://discord.gg/RbvHtQXF2B)
  - [Garuda Linux Forums](https://forum.garudalinux.org/)

---

## 📄 License

This project is licensed under the **GNU General Public License v3.0** - See the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Found an issue or have suggestions? Feel free to:
- Report bugs via [GitHub Issues](https://github.com/princedimond/garuda-nix/issues)
- Submit improvements via [Pull Requests](https://github.com/princedimond/garuda-nix/pulls)
- Discuss on [GitHub Discussions](https://github.com/princedimond/garuda-nix/discussions)

---

## 📞 Contact & Support

- **Repository Owner**: [@princedimond](https://github.com/princedimond)
- **Issues**: [GitHub Issues](https://github.com/princedimond/garuda-nix/issues)
- **Discussions**: [GitHub Discussions](https://github.com/princedimond/garuda-nix/discussions)

---

<div align="center">

**Built with ❤️ using NixOS and Garuda Linux**

*Last Updated: 2026-04-24*

</div>
