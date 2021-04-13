{
  pkgs2003 = import ./pins/pkgs-from-json.nix { json = ./pins/nixos-20-03.json; }; # To sync ghc and ghcide with Reflex-Platform.

  unstable = import <nixos-unstable> {};
}