{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin.url  = "github:lnl7/nix-darwin";

    node-red.url =
      "github:Victory-Family-Church/node-red-midi-ola";
  };

  outputs = { self, nixpkgs, darwin, node-red }:
  {
    darwinConfigurations.my-mac =
      darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          node-red.darwinModules.node-red-midi-ola
          {
            services.nodeRedMidiOla = {
              enable = true;
              port = 1880;
            };
          }
        ];
      };
  };
}
