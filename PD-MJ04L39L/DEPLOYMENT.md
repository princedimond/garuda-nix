# Deployment Configuration Guide

This guide explains how to use the centralized `variables.nix` system for different deployments.

## Overview

The `variables.nix` file contains all deployment-specific variables that may differ between systems. This allows you to:

- Deploy the same configuration to different machines with different settings
- Easily switch between keyboard layouts, time zones, and user accounts
- Keep the main configuration files generic and reusable

## Variables Configuration

Edit `variables.nix` to customize your deployment:

```nix
{
  # System identification
  hostName = "YOUR-HOSTNAME";           # Machine hostname
  userName = "yourusername";            # Primary user account name
  
  # Regional settings
  timeZone = "America/Chicago";         # Your timezone (default)
  locale = "en_US.UTF-8";              # System locale
  
  # Keyboard configuration
  keyboard = {
    layout = "us";                      # Primary keyboard layout
    additionalLayouts = [];             # Additional layouts (e.g., ["us", "de"])
    variant = "";                       # Layout variant (usually empty)
    options = [];                       # X11 keyboard options
  };
  
  # User home directory (automatically derived from userName)
  homeDirectory = "/home/yourusername";
  
  # Locale settings (all using the same locale by default)
  localeSettings = {
    # ... (automatically configured)
  };
}
```

## Example Configurations

### US English (Default)
```nix
{
  hostName = "desktop-us";
  userName = "john";
  timeZone = "America/Chicago";
  locale = "en_US.UTF-8";
  keyboard = {
    layout = "us";
    additionalLayouts = [];
    variant = "";
    options = [];
  };
  homeDirectory = "/home/john";
  # ... rest of config
}
```

### German System
```nix
{
  hostName = "laptop-de";
  userName = "klaus";
  timeZone = "Europe/Berlin";
  locale = "de_DE.UTF-8";
  keyboard = {
    layout = "de";
    additionalLayouts = ["us"];  # US as secondary layout
    variant = "";
    options = ["grp:alt_shift_toggle"];  # Alt+Shift to switch
  };
  homeDirectory = "/home/klaus";
  localeSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
}
```

### Multi-layout Setup
```nix
{
  hostName = "workstation";
  userName = "polyglot";
  timeZone = "UTC";
  locale = "en_US.UTF-8";
  keyboard = {
    layout = "us,fr,de";              # Multiple layouts
    additionalLayouts = ["us", "fr", "de"];
    variant = "";
    options = [
      "grp:alt_shift_toggle"          # Alt+Shift to cycle layouts
      "compose:ralt"                  # Right Alt as compose key
    ];
  };
  homeDirectory = "/home/polyglot";
  # ... rest of config
}
```

## Deployment Steps

1. **Copy Configuration**: Copy your Nix configuration to the new system
2. **Edit Variables**: Modify `variables.nix` with system-specific values
3. **Build Configuration**: Run `sudo nixos-rebuild switch --flake .#<hostname>`

## Files That Use Variables

The following files automatically reference the variables:

- **`configuration.nix`**: Uses `hostName`, `userName`, `timeZone`, `locale`, `localeSettings`
- **`home.nix`**: Uses `userName`, `homeDirectory`
- **`services.nix`**: Uses `keyboard.layout`, `keyboard.variant`
- **`flake.nix`**: Uses `hostName` for configuration naming

## Keyboard Layout Reference

Common keyboard layouts and their codes:

- **US English**: `us`
- **German**: `de`
- **French**: `fr`
- **Spanish**: `es`
- **Italian**: `it`
- **UK English**: `gb`
- **Dvorak**: `us` with variant `dvorak`
- **Colemak**: `us` with variant `colemak`

## Time Zone Reference

Common time zones:

- **US Eastern**: `America/New_York`
- **US Central**: `America/Chicago`
- **US Mountain**: `America/Denver`
- **US Pacific**: `America/Los_Angeles`
- **UTC**: `UTC`
- **London**: `Europe/London`
- **Berlin**: `Europe/Berlin`
- **Tokyo**: `Asia/Tokyo`

## Notes

- When changing the hostname, make sure to rebuild with the new hostname: `sudo nixos-rebuild switch --flake .#<new-hostname>`
- The `homeDirectory` should match the `userName` (typically `/home/<username>`)
- If you add keyboard options, separate them with commas in the list format
- Locale settings will automatically be updated when you change the main `locale` setting
