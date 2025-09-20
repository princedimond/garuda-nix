# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a Garuda NixOS configuration repository containing multiple system configurations for different machines. Each subdirectory (PD-*, matching machine hostnames) contains a complete NixOS system configuration using the Garuda Linux subsystem.

## Architecture

### Multi-Machine Configuration Structure
- Each machine has its own directory named by hostname (e.g., `PD-5CD8472PP3`, `PD-5CG9235MQ9`)
- All configurations follow a consistent structure with these key files:
  - `flake.nix` - Nix flake defining inputs and system configuration
  - `configuration.nix` - Main NixOS system configuration
  - `hardware-configuration.nix` - Hardware-specific configuration (auto-generated)
  - `home.nix` - Home Manager user environment configuration
  - `plasma.nix` - KDE Plasma desktop environment customizations
  - `flake.lock` - Locked dependency versions for reproducibility
  - `flake.lock.good` - Known-good backup of working flake.lock

### Key Dependencies and Inputs
- **nixpkgs**: Main NixOS package repository (unstable channel)
- **garuda**: Garuda Linux NixOS subsystem for dr460nized desktop
- **home-manager**: Declarative user environment management
- **plasma-manager**: KDE Plasma configuration management
- **nixvim**: Custom Neovim distribution
- **zen-browser**: Alternative Firefox-based browser
- **nix-flatpak**: Declarative Flatpak package management

### System Configuration Patterns
- All systems use systemd-boot with EFI
- Latest Linux kernel (`linuxPackages_latest`)
- LUKS disk encryption enabled
- Garuda dr460nized desktop environment with performance tweaks
- CachyOS kernel optimizations
- Automatic Nix store optimization and garbage collection

## Common Development Commands

### Building and Deploying Configurations
```bash
# Switch to a new configuration (from within a machine directory)
sudo nixos-rebuild switch --flake .

# Test a configuration without making it the boot default
sudo nixos-rebuild test --flake .

# Build configuration without activating
sudo nixos-rebuild build --flake .

# Update flake inputs to latest versions
nix flake update

# Show flake configuration info
nix flake show
```

### Using NH (NixOS Helper)
The `nh` package is installed system-wide for easier NixOS operations:
```bash
# Rebuild and switch (equivalent to nixos-rebuild switch)
nh os switch

# Update system
nh os switch --update

# Show system generations
nh os list

# Clean old generations
nh clean all
```

### Home Manager Operations
```bash
# Build home configuration (from machine directory)
home-manager switch --flake .

# Or use nh if available
nh home switch
```

### Package Management
```bash
# Search for packages
nix search nixpkgs <package-name>

# Install packages temporarily
nix shell nixpkgs#<package-name>

# Run a package without installing
nix run nixpkgs#<package-name>
```

### Flake Management
```bash
# Check flake for issues
nix flake check

# Update a specific input
nix flake lock --update-input <input-name>

# Pin flake.lock to current working version
cp flake.lock flake.lock.good
```

### System Maintenance
```bash
# Garbage collect old generations (configured to run weekly)
sudo nix-collect-garbage -d

# Optimize nix store
sudo nix-store --optimise

# Check system status
systemctl status
```

### Flatpak Management
Flatpak apps are managed declaratively in `configuration.nix`:
```bash
# Install declared Flatpaks manually if needed
flatpak install flathub <app-id>

# List installed Flatpaks
flatpak list
```

## Working with Multiple Machine Configurations

### Adding a New Machine Configuration
1. Copy an existing machine directory as template
2. Update `networking.hostName` in `configuration.nix`
3. Generate new `hardware-configuration.nix` with `nixos-generate-config`
4. Update the nixosConfigurations in `flake.nix` with new hostname
5. Adjust LUKS device UUIDs and other hardware-specific settings

### Synchronizing Configurations
- Common packages and settings can be extracted into shared modules
- Use `git` to track and sync configuration changes across machines
- Keep `flake.lock.good` as a known-working state backup

### Configuration Testing
- Always test with `nixos-rebuild test` before switching
- Use separate branches for experimental changes
- Keep backups of working configurations before major updates

## Troubleshooting

### Boot Issues
- Use previous generation from systemd-boot menu if current fails
- Check systemd journal: `journalctl -b` for boot messages
- Restore from `flake.lock.good` if flake update breaks system

### Package Conflicts
- Check for unfree packages in `nixpkgs.config.allowUnfree`
- Review `permittedInsecurePackages` for security exceptions
- Use `nix-store --verify --check-contents` to verify store integrity

### Home Manager Issues
- Rebuild home configuration separately from system
- Check for conflicting package installations between system and user level
- Review home-manager service logs: `journalctl --user -u home-manager-*`
