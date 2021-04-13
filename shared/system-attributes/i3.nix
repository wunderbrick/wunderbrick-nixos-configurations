{ config, pkgs, ... }:

{
  services = {
    xserver = {
      displayManager.gdm = { enable = true; };
      windowManager.i3 = { enable = true; };
    };
  };

  # TODO: figure out.
  #environment = {
  #    etc = {
  #      # Put config files in /etc. Note that you also can put these in ~/.config, but then you can't manage them with NixOS anymore!
  #      "xdg/i3/config".source = ../dotfiles/i3/config;
  #      "xdg/.config/eww/eww.xml".source = ../dotfiles/eww/eww.xml;
  #      "xdg/.config/eww/eww.scss".source = ../dotfiles/eww/eww.scss;
  #      "xdg/.config/eww/scripts/open-chromium.sh".source = ../dotfiles/eww/scripts/open-chromium.sh;
  #      "xdg/.config/eww/scripts/open-kodi.sh".source = ../dotfiles/eww/scripts/open-kodi.sh;
  #    };
  #  };
}
