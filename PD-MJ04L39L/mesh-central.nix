# mesh-central.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.meshCentral;
in

{
  options.meshCentral = {
    enable = mkEnableOption "MeshCentral agent installation and management";

    server = mkOption {
      type = types.str;
      description = "MeshCentral server URL (e.g. https://10.10.1.69)";
      example = "https://10.10.1.69";
    };

    token = mkOption {
      type = types.str;
      description = "MeshCentral agent token. Consider using tokenFile instead.";
      default = "";
    };

    # Better: read the token from a file not in the Nix store
    tokenFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to a file containing the MeshCentral agent token.
        Preferred over `token` to avoid storing secrets in the Nix store.
        e.g. /run/secrets/meshcentral-token (if using agenix or sops-nix)
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional arguments to pass to the MeshCentral installer";
    };

    noProxy = mkOption {
      type = types.bool;
      default = false;
      description = "Disable proxy when downloading the installer";
    };

    disableCertificateCheck = mkOption {
      type = types.bool;
      default = false;
      description = "Skip TLS certificate verification (useful for self-signed certs on LAN)";
    };

    runOnce = mkOption {
      type = types.bool;
      default = true;
      description = "Only install on first boot. Uses a marker file to track state.";
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.token != "" || cfg.tokenFile != null;
        message = "meshCentral: either token or tokenFile must be set";
      }
    ];

    # wget is needed by the MeshCentral install script internally
    environment.systemPackages = [ pkgs.wget ];

    systemd.services.mesh-central-installer = {
      description = "MeshCentral Agent Installer";

      wantedBy = [ "multi-user.target" ];
      after    = [ "network-online.target" ];
      wants    = [ "network-online.target" ];

      serviceConfig = {
        Type            = "oneshot";
        RemainAfterExit = true;
        # Runs as root so the agent can install its own systemd service
        User            = "root";
      };

      path = with pkgs; [ bash curl wget coreutils ];

      script = ''
        ${optionalString cfg.runOnce ''
          if [ -f /var/lib/mesh-central-installer/.installed ]; then
            echo "[mesh-central] already installed, skipping"
            exit 0
          fi
        ''}

        # Resolve the token
        ${if cfg.tokenFile != null then ''
          TOKEN=$(cat ${escapeShellArg cfg.tokenFile})
        '' else ''
          TOKEN=${escapeShellArg cfg.token}
        ''}

        echo "[mesh-central] downloading installer from ${cfg.server}..."
        curl \
          ${optionalString cfg.disableCertificateCheck "-k"} \
          ${optionalString cfg.noProxy "--noproxy '*'"} \
          -fsSL \
          -o /tmp/meshinstall.sh \
          "${cfg.server}/meshagents?script=1"

        chmod +x /tmp/meshinstall.sh

        echo "[mesh-central] running installer..."
        /tmp/meshinstall.sh \
          "${cfg.server}" \
          "$TOKEN" \
          ${escapeShellArgs cfg.extraArgs}

        rm -f /tmp/meshinstall.sh

        ${optionalString cfg.runOnce ''
          mkdir -p /var/lib/mesh-central-installer
          touch /var/lib/mesh-central-installer/.installed
          echo "[mesh-central] marker created, won't re-run on next boot"
        ''}
      '';
    };

    # Ensure the agent's own service stays running after install
    # MeshCentral installs itself as 'meshagent' — keep it enabled
    systemd.services.meshagent = {
      enable  = true;
      wantedBy = [ "multi-user.target" ];
      after    = [ "mesh-central-installer.service" ];
    };
  };
}
