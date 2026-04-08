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
      description = "Persistent Node-RED user directory.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 1880;
    };
  };

  config = lib.mkIf cfg.enable {

    users.users.nodered = {
      isSystemUser = true;
      home = cfg.userDir;
      createHome = true;
    };

    launchd.daemons.node-red = {
      enable = true;

      config = {
        Label = "org.vfc.node-red";

        ProgramArguments = [
          "/bin/sh"
          "-c"
          ''
            set -e

            export NODE_RED_HOME=${cfg.userDir}

            # ---- Guards -------------------------------------------------

            mkdir -p "$NODE_RED_HOME"
            mkdir -p "$NODE_RED_HOME/node_modules"

            chown -R nodered "$NODE_RED_HOME"

            # ---- Start Node-RED ----------------------------------------

            exec ${pkgs.node-red}/bin/node-red \
              --userDir "$NODE_RED_HOME" \
              --port ${toString cfg.port}
          ''
        ];

        UserName = "nodered";
        RunAtLoad = true;
        KeepAlive = true;

        StandardOutPath = "/var/log/node-red.log";
        StandardErrorPath = "/var/log/node-red.err";
      };
    };
  };
}