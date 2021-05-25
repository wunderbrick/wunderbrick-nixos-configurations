{ config, pkgs, ... }:

{
  services = {
    xserver = {
      displayManager = {
        gdm = { enable = true; };
        defaultSession = "sway";
      };
      desktopManager.gnome3 = { enable = true; };
    };
  };
}
