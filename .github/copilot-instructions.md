# Copilot Instructions for garuda-nix

## Project Overview

This is a **NixOS configuration repository** based on Garuda Linux, using Nix Flakes for reproducible system management. The repository contains multiple deployment configurations (PD-* directories), each representing a different system's setup. The active configuration in the cwd is managed through `flake.nix` and modular `.nix` files.

## Key Architecture

### Directory Structure
- **Root `flake.nix`**: Defines inputs (nixpkgs, home-manager, garuda-nix-subsystem, etc.) and outputs the NixOS configuration
- **Per-deployment directories** (PD-9I73060TI, PD-MJ04L39L, etc.): Each contains a complete system configuration
  - `flake.nix`: Deployment-specific flake configuration
  - `configuration.nix`: Main system configuration (imports hardware-configuration, services, packages)
  - `home.nix`: Home Manager configuration for user environment
  - `variables.nix`: Deployment-specific variables (hostname, username, timezone, keyboard layout)
  - `services.nix`: System services configuration (X11 keymap, Flatpak, VPN, desktop managers)
  - `hardware-configuration.nix`: Hardware-specific settings (auto-generated)
  - `packages/`: Modular package organization
    - `system.nix`: System-wide packages (utilities, development tools)
    - `user.nix`: User-specific packages
    - `development.nix`: Development tools and IDEs
    - `virtualisation.nix`: Libvirtd/Podman/Docker configuration

### Central Design Pattern: Variables System
All deployment-specific values are defined in `variables.nix`. This file is imported by `configuration.nix`, `home.nix`, `services.nix`, and `flake.nix`. When modifying system configuration:
1. Check `variables.nix` first for deployment-specific customization points
2. Edit `configuration.nix` and related files for generic/shared logic
3. Modular imports in `configuration.nix` allow including/excluding features

## Build and Deployment Commands

### Building and Switching Configuration
```bash
# Switch to new configuration (rebuilds and activates)
sudo nixos-rebuild switch --flake .#<hostname>

# Test configuration without activating
sudo nixos-rebuild test --flake .#<hostname>

# Build without activating
sudo nixos-rebuild build --flake .#<hostname>

# Show what changed
sudo nixos-rebuild diff-closures --flake .#<hostname>
```

### Flake Operations
```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake update <input-name>

# Show flake info
nix flake show

# Check flake validity
nix flake check
```

### Debugging
```bash
# Show configuration output
nix eval --json .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Check for errors without building
nix flake check

# Evaluate a specific option
nix eval .#nixosConfigurations.<hostname>.config.<option.path>
```

## Key Conventions and Patterns

### Variables.nix Pattern
- Each deployment has a `variables.nix` that centralizes all customization points
- Variables are imported as a `let binding` in configuration files
- Changes to `variables.nix` propagate through all importing modules
- Always check this file when customizing a deployment

### Module Organization
- `configuration.nix` orchestrates imports (hardware, services, packages)
- Each `.nix` file in the root is a focused concern (services, plasma setup, Japanese support, etc.)
- Package definitions are split by category in `packages/` directory
- Commented-out imports in `home.nix` indicate optional features (plasma, polybar, etc.)

### Flake Input Management
- Uses Flake input pinning (`follows` pattern) to ensure consistent versions
- Main inputs: nixpkgs (25.11 channel), garuda-nix-subsystem, home-manager, plasma-manager
- Third-party flakes like `zen-browser` and `nix-flatpak` are configured with shared dependencies

### Common Overrides and Workarounds
- Kernel locked to 6.18 for Nvidia driver stability (see `configuration.nix`)
- Permissive package list includes unsupported/insecure packages (libsoup-2.74.3, electron-35.7.5, ventoy-1.1.10)
- Plasma is force-set as default session to prevent conflicts with Pantheon
- Comments in code indicate incomplete/experimental features (orca-slicer overlay is commented out)

### Adding Packages
- User packages: Uncomment categories in `home.nix` (development, utilities, media, productivity, shell)
- System packages: Add to relevant category in `packages/system.nix`
- Development tools: Add to `packages/development.nix`
- New package categories: Create new `.nix` file in `packages/` and import in the relevant config

### Keyboard and Locale Customization
- Keyboard layout, variants, and options are managed in `variables.nix`
- Multiple layouts can be configured with X11 keyboard options (e.g., `grp:alt_shift_toggle`)
- Locale settings are auto-configured from the main `locale` setting but can be overridden in `localeSettings` object

## Dependencies and Tools

### Required Tools
- `nix` with Flake support enabled
- `git` for version control

### Key External Dependencies (defined in flake.nix)
- `nixpkgs`: Nixos 25.11 channel
- `home-manager`: User environment management
- `garuda-nix-subsystem`: Garuda-specific system defaults
- `plasma-manager`: KDE Plasma configuration management
- `nix-flatpak`: Flatpak integration
- `nixvim`: Neovim configuration framework
- `zen-browser-flake`: Zen browser (requires updated libgbm from unstable)

## Important Notes

- **Hostname Linking**: When changing `hostName` in `variables.nix`, ensure it matches the flake output name and rebuild with `sudo nixos-rebuild switch --flake .#<new-hostname>`
- **Home Manager Integration**: Currently commented out in system flake but modules available; some functionality delegated to `home.nix`
- **GPU Acceleration**: Nvidia drivers are configured; some apps require specific environment variables for GPU support (see commented orca-slicer example)
- **Minimal README**: Root README.md is minimal; most documentation is in DEPLOYMENT.md
