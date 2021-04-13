{ config, pkgs, ... }:

{
  security = {
    polkit.enable = true;
    chromiumSuidSandbox.enable =
      true; # https://github.com/NixOS/nixpkgs/issues/97682 with hardened kernel
  };
}
