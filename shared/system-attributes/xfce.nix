{ config, pkgs, ... }:

{
  services = {
    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.xfce.enable = true;
    };
  };
}
