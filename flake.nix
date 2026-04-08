{
  description = "Lighting Control Workspace – Node-RED with MIDI + OLA (Darwin)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin }:
  let
    ##########################################################################
    # Overlay: build Node-RED using modern buildNpmPackage
    ##########################################################################
    overlay = final: prev: {
      node-red = prev.buildNpmPackage rec {
        pname = "node-red";
        version = "4.1.8";

        src = final.fetchurl {
          url = "https://registry.npmjs.org/node-red/-/node-red-${version}.tgz";
          hash = "sha256-t+HPUWiUVTIyrQ1FE5CdBiCm1XIRpIWUgje0dy20Yf4=";
        };

        # Vendored lockfile (committed to this repo)
        npmLock = ./resources/locks/node-red/package-lock.json;

        # Fill this once with the value Nix prints on first build
        npmDepsHash = "sha256-RgtcYAg8sWQiKQhPc5sMvnVa07iD3QfKi8iMlph79ck=";
         postPatch = ''    cp ${./resources/locks/node-red/package-lock.json} package-lock.json  '';
        # Node-RED has no compile step
        dontNpmBuild = true;
        installPhase = ''  
          runHook preInstall  
          mkdir -p $out  
          cp -r . $out  
          runHook postInstall
          '';
      };
      node-red-contrib-midi = prev.buildNpmPackage rec {
          pname = "node-red-contrib-midi";
          version = "1.1.2";

          src = final.fetchurl {
            url = "https://registry.npmjs.org/node-red-contrib-midi/-/node-red-contrib-midi-${version}.tgz";
            hash = "sha256-R4f67TUP+9MaJ1fE6E2AX3Gp+CQ8ELKAWXT5XjzDUPE==";
          };
        # Vendored lockfile (committed to this repo)
        npmLock = ./resources/locks/node-red/package-lock.json;

        # Fill this once with the value Nix prints on first build
        npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        postPatch = ''    cp ${./resources/locks/node-red/package-lock.json} package-lock.json  '';
        dontNpmBuild = true;

        };

        node-red-contrib-ola = prev.buildNpmPackage rec {
          pname = "node-red-contrib-ola";
          version = "0.0.4";

          src = final.fetchurl {
            url = "https://registry.npmjs.org/node-red-contrib-ola/-/node-red-contrib-ola-${version}.tgz";
            hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };

        # Vendored lockfile (committed to this repo)
        npmLock = ./resources/locks/node-red/package-lock.json;

        # Fill this once with the value Nix prints on first build
        npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        postPatch = ''    cp ${./resources/locks/node-red/package-lock.json} package-lock.json  '';
        dontNpmBuild = true;

        };
    };
  in
  {
    ##########################################################################
    # Export overlay (useful standalone, but optional)
    ##########################################################################
    overlays.default = overlay;
    packages.aarch64-darwin.node-red =  let    pkgs = import nixpkgs {      system = "aarch64-darwin";      overlays = [ overlay ];    };  in  pkgs.node-red;
    packages.aarch64-darwin.node-red-contrib-ola =  let    pkgs = import nixpkgs {      system = "aarch64-darwin";      overlays = [ overlay ];    };  in  pkgs.node-red-contrib-ola;
    packages.aarch64-darwin.node-red-contrib-midi =  let    pkgs = import nixpkgs {      system = "aarch64-darwin";      overlays = [ overlay ];    };  in  pkgs.node-red-contrib-midi;

    ##########################################################################
    # nix-darwin module (overlay auto-applied)
    ##########################################################################
    darwinModules.node-red-midi-ola = { ... }: {
      imports = [
        ./modules/node-red-midi-ola.nix
      ];

      nixpkgs.overlays = [ overlay ];
    };

    ##########################################################################
    # Development shell – mirrors real Node-RED usage
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
        ];

        shellHook = ''
          echo
          echo "Node-RED development shell"
          echo "================================"
          echo

          export NODE_RED_HOME=$PWD/node-red-data
          mkdir -p "$NODE_RED_HOME"

          echo "Install contrib nodes (once):"
          echo "  npm --prefix $NODE_RED_HOME install \\"
          echo "    node-red-contrib-midi \\"
          echo "    node-red-contrib-ola"
          echo
          echo "Run Node-RED:"
          echo "  node-red --userDir $NODE_RED_HOME"
          echo
        '';
      };
  };
}