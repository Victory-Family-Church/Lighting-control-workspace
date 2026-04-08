{ config, lib, pkgs, ... }:

let
  cfg = config.services.nodeRed;
in
{
  options.services.nodeRed = {
    enable = lib.mkEnableOption "Node-RED service";

    userDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/node-red";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 1880;
    };
  };

  config = lib.mkIf cfg.enable {

    # Darwin user definition (no isSystemUser on macOS)
    users.users.nodered = {
      home = cfg.userDir;
      createHome = true;
      isHidden = true;
    };

    # ✅ THIS is the entire allowed launchd definition
    launchd.daemons.node-red = {
      enable = true;

      script = ''
        set -e

        export NODE_RED_HOME=${cfg.userDir}

        mkdir -p "$NODE_RED_HOME"
        mkdir -p "$NODE_RED_HOME/node_modules"
        chown -R nodered "$NODE_RED_HOME"

        exec ${pkgs.node-red}/bin/node-red \
          --userDir "$NODE_RED_HOME" \
          --port ${toString cfg.port}
      '';

      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        UserName = "nodered";
        StandardOutPath = "/var/log/node-red.log";
        StandardErrorPath = "/var/log/node-red.err";
      };
    };

    # Darwin-only: allow broken OLA package
    nixpkgs.config.problems.handlers =
      lib.mkIf pkgs.stdenv.isDarwin {
        ola.broken = "ignore";
      };
  };
}
