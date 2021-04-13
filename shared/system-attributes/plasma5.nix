{ config, pkgs, ... }:

{
  services = {
    xserver = {
      displayManager.gdm = {
        enable = true;
      }; # lightdm in 20.09 fails to launch redshit with sway.
      desktopManager.plasma5 = { enable = true; };
    };
  };
}
