# Deployment-specific variables
# Modify these values for different deployments/systems

{
  # System identification
  hostName = "PD-9I73060TI";
  userName = "princedimond";

  # Regional settings
  timeZone = "America/Chicago";
  locale = "en_US.UTF-8";

  # Keyboard configuration
  keyboard = {
    # Primary keyboard layout
    layout = "us";

    # Additional keyboard layouts (if any)
    # Example: ["us", "de", "fr"] for US English, German, French
    additionalLayouts = [ ];

    # Keyboard variant (usually empty for standard layouts)
    variant = "";

    # X11 keyboard options (optional)
    # Example: "grp:alt_shift_toggle" to switch layouts with Alt+Shift
    options = [ ];
  };

  # User home directory (derived from userName)
  homeDirectory = "/home/princedimond";

  # Additional locale settings (all using the same locale by default)
  localeSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
