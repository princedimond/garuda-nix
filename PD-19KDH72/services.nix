# Services configuration
{ config, pkgs, ... }:

{
  # System services configuration
  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Flatpak service and packages
    flatpak = {
      enable = true;
      packages = [
        "com.microsoft.Edge"
      ];
    };

    # Hardware services
    hardware.bolt.enable = true;

    # VPN and networking services
    expressvpn.enable = true;
    tailscale.enable = true;

    # Printing service
    printing.enable = true; # enable CUPS to print documents

    # Remote access
    teamviewer.enable = true;

    # Enable the OpenSSH daemon (currently commented out)
    # openssh.enable = true;
  };

  # Custom systemd services
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak install -y microsoft-edge
    '';
  };
}
