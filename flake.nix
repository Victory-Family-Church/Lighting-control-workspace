{
  description = "Node-RED with MIDI + OLA (Darwin launchd module, overlay, and devShell)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin }:
  let
    ##########################################################################
    # Overlay: adds Node-RED and contrib nodes to nodePackages
    ##########################################################################
    overlay = final: prev: {
      nodePackages = prev.nodePackages // {

        node-red = prev.nodePackages.buildNodePackage rec {
          pname = "node-red";
          version = "4.1.8";

          src = prev.fetchurl {
            url =
              "https://registry.npmjs.org/node-red/-/node-red-${version}.tgz";
            hash = "2n9nvkd5ds5jdkyry3c9m6v0djhfz22py89wd2dyz5xm5vmdrp376z2ni8138h0wwy3xg3agxcr62wj90xxhm98ll9gwfykhr704y71";
          };
        };

        node-red-contrib-midi =
          prev.nodePackages.buildNodePackage rec {
            pname = "node-red-contrib-midi";
            version = "1.1.2";

            src = prev.fetchurl {
              url =
                "https://registry.npmjs.org/node-red-contrib-midi/-/node-red-contrib-midi-${version}.tgz";
              hash = "2wrwaj7qln7parcxvicl4nd9bfckhflp11p2d022by1l8dbb2bzcpapqdi8q7lig5wipj440wjar01jnf41vci72vikbb7nzw7n06y3";
            };
          };

        node-red-contrib-ola =
          prev.nodePackages.buildNodePackage rec {
            pname = "node-red-contrib-ola";
            version = "0.0.4";

            src = prev.fetchurl {
              url =
                "https://registry.npmjs.org/node-red-contrib-ola/-/node-red-contrib-ola-${version}.tgz";
              hash = "08889yyv7bjra5gsyknv1vqrwyjmx2xkl4yp226ijp6ns7nfzmzdqvk6m5g3zrgk1jm6qd54ipxqk35lfisxal51cqyqbkbk2c98vlf";
            };
          };
      };
    };
  in
  {
    ##########################################################################
    # Export overlay (optional for advanced users)
    ##########################################################################
    overlays.default = overlay;

    ##########################################################################
    # nix-darwin module (overlay applied automatically)
    ##########################################################################
    darwinModules.node-red-midi-ola = { ... }: {
      imports = [
        ./modules/node-red-midi-ola.nix
      ];

      nixpkgs.overlays = [ overlay ];
    };

    ##########################################################################
    # devShell: `nix develop`
    ##########################################################################
    devShells.default =
      let
        system =
          builtins.currentSystem or "aarch64-darwin";

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
      in
      pkgs.mkShell {
        name = "node-red-midi-ola-shell";

        packages = [
          pkgs.nodejs_20
          pkgs.nodePackages.node-red
          pkgs.nodePackages.node-red-contrib-midi
          pkgs.nodePackages.node-red-contrib-ola
          pkgs.ola
        ];

        NODE_PATH = pkgs.lib.makeSearchPath "lib/node_modules" [
          pkgs.nodePackages.node-red
          pkgs.nodePackages.node-red-contrib-midi
          pkgs.nodePackages.node-red-contrib-ola
        ];

        shellHook = ''
          echo "Node-RED dev shell"
          echo "Run:"
          echo "  node ${pkgs.nodePackages.node-red}/lib/node_modules/node-red/red.js \\"
          echo "    --userDir ./node-red-data"
          echo

          export NODE_RED_HOME=$PWD/node-red-data
          mkdir -p "$NODE_RED_HOME"
        '';
      };
  };
}
