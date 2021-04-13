{ config, pkgs, ... }:

{
  programs = {
    dconf.enable =
      true; # running Gnome programs outside of Gnome according to the wiki
    bash.enableCompletion = true;
    light.enable = true;
    adb.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    qt5ct.enable = true;
  };
}
