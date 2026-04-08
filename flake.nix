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
  node-red = prev.buildNpmPackage rec {
    pname = "node-red";
    version = "4.1.8";

    src = final.fetchurl {
      url = "https://registry.npmjs.org/node-red/-/node-red-${version}.tgz";
      hash = "sha256-t+HPUWiUVTIyrQ1FE5CdBiCm1XIRpIWUgje0dy20Yf4=";
    };

    npmLock = ./resources/locks/node-red/package-lock.json;
    npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    dontNpmBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -r . $out
      makeWrapper ${prev.nodejs}/bin/node $out/bin/node-red \
        --add-flags $out/node_modules/node-red/red.js
    '';
  };

  node-red-contrib-midi = prev.buildNpmPackage rec {
    pname = "node-red-contrib-midi";
    version = "1.1.2";

    src = final.fetchurl {
      url = "https://registry.npmjs.org/node-red-contrib-midi/-/node-red-contrib-midi-${version}.tgz";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  };

  node-red-contrib-ola = prev.buildNpmPackage rec {
    pname = "node-red-contrib-ola";
    version = "0.0.4";

    src = final.fetchurl {
      url = "https://registry.npmjs.org/node-red-contrib-ola/-/node-red-contrib-ola-${version}.tgz";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
    devShells.aarch64-darwin.default =
      let
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = [ overlay ];
        };
      in
      pkgs.mkShell {
        name = "node-red-midi-ola-shell";

        packages = [
          pkgs.nodejs
          pkgs.node-red
          pkgs.node-red-contrib-midi
          pkgs.node-red-contrib-ola
        ];

        NODE_PATH = pkgs.lib.makeSearchPath "lib/node_modules" [
          pkgs.node-red
          pkgs.node-red-contrib-midi
          pkgs.node-red-contrib-ola
        ];

        shellHook = ''
          echo "Node-RED dev shell"
          export NODE_RED_HOME=$PWD/node-red-data
          mkdir -p "$NODE_RED_HOME"
        '';
      };
  };
}
