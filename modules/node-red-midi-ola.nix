{ config, lib, pkgs, ... }:

let
  cfg = config.services.nodeRedMidiOla;
in
{
  options.services.nodeRedMidiOla = {
    enable = lib.mkEnableOption "Node-RED with MIDI + OLA (launchd)";

    port = lib.mkOption {
      type = lib.types.port;
      default = 1880;
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "nodered";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/node-red";
    };
  };

  config = lib.mkIf cfg.enable {

    users.users.${cfg.user} = {
      home = cfg.dataDir;
      createHome = true;
      isHidden = true;
    };

    environment.systemPackages = [
      pkgs.nodejs_20
      pkgs.nodePackages.node-red
      pkgs.nodePackages.node-red-contrib-midi
      pkgs.nodePackages.node-red-contrib-ola
      pkgs.ola
    ];

    launchd.daemons.node-red-midi-ola = {
      enable = true;

      config = {
        Label = "org.nixos.node-red-midi-ola";

        ProgramArguments = [
          "${pkgs.nodejs_20}/bin/node"
          "${pkgs.nodePackages.node-red}/lib/node_modules/node-red/red.js"
          "--userDir"
          cfg.dataDir
          "--port"
          (toString cfg.port)
        ];

        EnvironmentVariables = {
          NODE_RED_HOME = cfg.dataDir;
          NODE_PATH = lib.makeSearchPath "lib/node_modules" [
            pkgs.nodePackages.node-red
            pkgs.nodePackages.node-red-contrib-midi
            pkgs.nodePackages.node-red-contrib-ola
          ];
        };

        UserName = cfg.user;
        GroupName = "staff";

        WorkingDirectory = cfg.dataDir;

        RunAtLoad = true;
        KeepAlive = true;

        StandardOutPath = "/var/log/node-red.log";
        StandardErrorPath = "/var/log/node-red.err";
      };
    };
  };
}
