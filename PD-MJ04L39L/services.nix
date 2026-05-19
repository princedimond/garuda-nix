# Services configuration
{ config, pkgs, lib, ... }:

let
  vars = import ./variables.nix;
in
{
  # System services configuration
  services = {
    spice-vdagentd.enable = true;
    # Configure keymap in X11
    xserver.xkb = {
      layout = vars.keyboard.layout;
      variant = vars.keyboard.variant;
    };
    samba = {
      enable = true;
      openFirewall = true;
      /*
      settings = ''
      workgroup = WORKGROUP
      server string = NixOS Samba Server
      map to guest = Bad User
    '';
    */
    };
    #samba-wssd.enable = true;
    cockpit = {
      enable = true;
      /*
      plugins = [
        pkgs.cockpit-files
        pkgs.cockpit-zfs
        pkgs.cockpit-podman
        pkgs.cockpit-machines
      ];
      */
      openFirewall = true;
      port = 9090;
      settings.webService.allowUnencrypted = true;
    };



    # Flatpak service and packages
    flatpak = {
      enable = true;
      packages = [
        #"com.microsoft.Edge"
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

    # Enable Input from keyboard and mouse on wayland
    libinput.enable = true;

    # Enable the OpenSSH daemon (currently commented out)
     openssh.enable = true;
  };

  # Custom Enables
  programs = {
    virt-manager.enable = true;
  };

  # Custom systemd services
  systemd.services.cockpit = {
    environment.PATH = lib.mkDefault "${pkgs.cockpit}/libexec:${pkgs.sscg}/bin:${pkgs.coreutils}/bin";
  };
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      # flatpak install -y microsoft-edge
    '';
  };
}
