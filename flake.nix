{
  description = "Lighting Control Workspace – Node-RED (Darwin)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin }:
  let
    overlay = final: prev: {
      node-red = prev.buildNpmPackage rec {
        pname = "node-red";
        version = "4.1.8";

        src = final.fetchurl {
          url = "https://registry.npmjs.org/node-red/-/node-red-${version}.tgz";
          hash = "sha256-t+HPUWiUVTIyrQ1FE5CdBiCm1XIRpIWUgje0dy20Yf4=";
        };

        # Lockfile generated and committed in resources/locks/node-red/
        postPatch = ''
          cp ${./resources/locks/node-red/package-lock.json} package-lock.json
        '';

        npmDepsHash = "sha256-RgtcYAg8sWQiKQhPc5sMvnVa07iD3QfKi8iMlph79ck=";
        dontNpmBuild = true;
      };
    };
  in
  {
    overlays.default = overlay;

    # Buildable package (useful for debugging)
    packages.aarch64-darwin.node-red =
      let
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = [ overlay ];
        };
      in
      pkgs.node-red;

    # nix-darwin service module
    darwinModules.node-red-midi-ola = import ./modules/node-red-midi-ola.nix;

    # Developer shell
    devShells.aarch64-darwin.default =
      let
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = [ overlay ];
        };
      in
      pkgs.mkShell {
        name = "node-red-dev-shell";

        packages = [
          pkgs.nodejs
          pkgs.node-red
        ];

        shellHook = ''
          echo ""
          echo "Node-RED development shell"
          echo "Run Node-RED with:"
          echo "  node-red --userDir ./node-red-data"
          echo ""
        '';
      };
  };
}