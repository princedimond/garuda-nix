{ pkgs, ... }:
{
  # Only enable either docker or podman -- Not both
  virtualisation = {
    libvirtd.enable = true;
    docker.enable = false;
    podman.enable = true;
  };
  programs = {
    virt-manager.enable = true;
  };
  environment.systemPackages = with pkgs; [
    virt-viewer # View Virtual Machines
  ];
}
