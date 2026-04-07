{
  description = "OLA with FTDI DMX support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = false;
        };

        # Override ola to ensure libftdi is included
        olaWithFtdi = pkgs.ola.override {
          libftdi1 = pkgs.libftdi1;
        };
      in {
        packages.default = olaWithFtdi;

        devShells.default = pkgs.mkShell {
          buildInputs = [ olaWithFtdi ];
        };
      });
}