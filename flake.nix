# MAKE SURE ALL THE HOSTNAMES AND FILES MATCH UP!

{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-20.09";
    };
    #rpi4pkgs = {
    #  url = "github:NixOS/nixpkgs/102eb68ceecbbd32ab1906a53ef5a7269dc9794a";
    #};
    agenix = {
      url = "github:ryantm/agenix";
    };
  };

  outputs = { self, nixpkgs, agenix }: #, rpi4pkgs }:
    let
      pkgs = (import nixpkgs) {
        system = "x86_64-linux";
      };

      #rpipkgs = (import rpi4pkgs) {
      #  system = "aarch64-linux";
      #};

      targets = map (pkgs.lib.removeSuffix ".nix") (
        pkgs.lib.attrNames (
          pkgs.lib.filterAttrs
            (_: entryType: entryType == "directory")
            (builtins.readDir ./targets)
        )
      );

      build-target = target:
      let
        thePkgs = nixpkgs; # if target == "rpi4-0" then rpi4pkgs else nixpkgs;
        theSys = if target == "rpi4-0" then "aarch64-linux" else "x86_64-linux";
      in
      {
        name = target;

        value = nixpkgs.lib.nixosSystem {
          system = theSys;

          modules = [
            (import (./targets + "/${target}/machine.nix"))
            (import (./targets + "/${target}/hardware-configuration.nix"))
            agenix.nixosModules.age
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