# MAKE SURE ALL THE HOSTNAMES AND FILES MATCH UP!

{
  inputs = {
      nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-20.09";
    };
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = (import nixpkgs) {
        system = "x86_64-linux";
      };

      targets = map (pkgs.lib.removeSuffix ".nix") (
        pkgs.lib.attrNames (
          pkgs.lib.filterAttrs
            (_: entryType: entryType == "directory")
            (builtins.readDir ./targets)
        )
      );

      build-target = target: {
        name = target;

        value = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            (import (./targets + "/${target}/machine.nix"))
            (import (./targets + "/${target}/hardware-configuration.nix"))
          ];
        };
      };

    in
    {
      nixosConfigurations = builtins.listToAttrs (
        pkgs.lib.flatten (
          map
            (
              target: [
                (build-target target)
              ]
            )
            targets
        )
      );
    };
}