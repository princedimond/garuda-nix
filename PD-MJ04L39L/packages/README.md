# Package Organization

This directory contains organized package definitions for your NixOS configuration.

## Structure

### `system.nix`
Contains system-level packages organized by category:
- **core**: Essential system utilities (wget, git, curl, etc.)
- **development**: Development tools and IDEs (vscode, nixd, etc.)
- **productivity**: Communication and productivity apps (discord, thunderbird, etc.)
- **networking**: VPN and networking tools (protonvpn, expressvpn, etc.)
- **media**: Media and graphics tools (gthumb, imagemagick, etc.)
- **utilities**: System utilities and file management tools
- **printing**: Printer-related packages
- **wine**: Wine compatibility layer packages
- **browsers**: Browser packages from flake inputs
- **extras**: Additional tools

### `user.nix`
Contains user-specific packages for home-manager:
- **development**: User development tools
- **utilities**: Personal utilities
- **media**: User media and entertainment
- **productivity**: Personal productivity tools
- **shell**: Shell and terminal enhancements

### `development.nix`
Contains specialized development packages:
- **languages**: Programming languages and runtimes
- **editors**: Development editors and IDEs
- **vcs**: Version control tools
- **build**: Build tools and package managers
- **databases**: Database tools and servers
- **containers**: Container and virtualization tools
- **api**: API testing and development tools
- **docs**: Documentation tools

## Usage

### Adding New Packages

#### System Packages
Edit `system.nix` and add packages to the appropriate category:
```nix
utilities = with pkgs; [
  existing-package
  new-package-name  # Add your new package here
];
```

#### User Packages
Edit `user.nix` and add packages to the appropriate category:
```nix
utilities = with pkgs; [
  # new-package-name  # Uncomment and add your package
];
```

Then in `home.nix`, uncomment the corresponding category:
```nix
# userPkgs.utilities ++  # Remove the # to enable this category
```

#### Development Packages
Edit `development.nix` and add packages to the appropriate category. Enable them in either:
- `configuration.nix` for system-wide availability
- `home.nix` for user-specific availability

### Enabling Package Categories

#### In `configuration.nix` (system-wide):
```nix
# devPkgs.languages ++     # Uncomment to enable
# devPkgs.databases ++     # Uncomment to enable
```

#### In `home.nix` (user-specific):
```nix
# userPkgs.utilities ++    # Uncomment to enable
# devPkgs.languages ++     # Uncomment to enable
```

## Benefits

1. **Organization**: Packages are grouped by function and purpose
2. **Modularity**: Easy to enable/disable entire categories
3. **Maintainability**: Changes to specific package groups are isolated
4. **Scalability**: Easy to add new categories or reorganize existing ones
5. **Flexibility**: Same packages can be used in both system and user contexts

## Applying Changes

After modifying package files:

1. Make sure files are tracked by git:
   ```bash
   git add packages/
   ```

2. Test your configuration:
   ```bash
   sudo nixos-rebuild dry-build --flake .#PD-19KDH72
   ```

3. Apply changes:
   ```bash
   sudo nixos-rebuild switch --flake .#PD-19KDH72
   ```
