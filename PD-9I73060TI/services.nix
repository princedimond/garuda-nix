# Services configuration
{
  config,
  pkgs,
  ...
}:

let
  vars = import ./variables.nix;
in
{
  # System services configuration
  services = {
    spice-vdagentd.enable = true;
    # Configure keymap in X11
    xserver = {
      xkb = {
        layout = vars.keyboard.layout;
        variant = vars.keyboard.variant;
      };
      videoDrivers = [ "nvidia" ];
    };

    # Flatpak service and packages
    flatpak = {
      enable = true;
      packages = [
        #"com.microsoft.Edge"
        #"com.mikrotik.WinBox"
        "io.github.astralvixen.geforce-infinity"
      ];
    };
    # Enable (make available) Cosmic Desktop Environment
    desktopManager.cosmic.enable = true;

    # VPN and networking services
    expressvpn.enable = true;
    tailscale.enable = true;

    # Printing service
    printing.enable = true; # enable CUPS to print documents

    # Remote access
    teamviewer.enable = true;

    # Enable the OpenSSH daemon (currently commented out)
    openssh.enable = true;

    # Enable Input from keyboard and mouse on wayland
    libinput.enable = true;

    # Hardware services
    #hardware.bolt.enable = true;
    hardware = {
      bolt.enable = true;
    };
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      /*
        # Override to add hostname to build dependencies
        package = config.boot.kernelPackages.nvidiaPackages.beta.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.inetutils ];
        });
      */
    };
  };

  # Custom Enables
  programs = {
    virt-manager.enable = true;
  };

  # Custom systemd services
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      #flatpak install -y microsoft-edge
      #flatpak install -y WinBox
      flatpak install -y geforce-infinity
    '';
  };
}
