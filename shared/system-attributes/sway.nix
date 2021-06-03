# https://nixos.wiki/wiki/Sway
# Looks like sway will be able to be started from display manager in next version: https://github.com/NixOS/nixpkgs/pull/75363
# All the systemd stuff isn't quite working (redshift-wlr, waybar, etc.) so for now I'm just starting redshift and waybar in the sway config with exec.
{ config, pkgs, ... }:

with pkgs; {
  programs.sway = {
    enable = true;
    extraPackages = [
      redshift-wlr
      swaylock # lockscreen
      swayidle
      swaybg # wallpaper
      xwayland # for legacy apps
      waybar
      mako # notification daemon
      #kanshi # autorandr
      wofi # rofi replacement
      grim # take screenshot
      slurp # select screen area
      xorg.xhost # Allow root to display applications on desktop for things like gparted. Run xhost +SI:localuser:root before gparted.
      libappindicator # tray
      libdbusmenu-gtk3 # tray
      wlr-randr
    ];
  };

  environment = {
    variables = {
      WLR_DRM_NO_ATOMIC = "1";
    }; # use legacy DRM mode instead of atomic interface. Maybe a Vega specific issue? Maybe my kernel's too old? TODO: find out.
    # https://www.reddit.com/r/swaywm/comments/bfa43r/i_cant_get_redshift_to_work/
    etc = {
      ################ DO NOT LEAVE AN i3 CONFIG AT ~/.config/i3 OR SWAY WILL PICK IT UP!
      # Put config files in /etc. Note that you also can put these in ~/.config, but then you can't manage them with NixOS anymore!
      "sway/config".source = ../dotfiles/sway/config;
      "xdg/waybar/config".source = ../dotfiles/waybar/config;
      "xdg/waybar/style.css".source = ../dotfiles/waybar/style.css;
    };
  };

  # Here we but a shell script into path, which lets us start sway.service (after importing the environment of the login shell).
  environment.systemPackages = with pkgs;
    [
      (pkgs.writeTextFile {
        name = "startsway";
        destination = "/bin/startsway";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/bash

          # first import environment variables from the login manager
          systemctl --user import-environment
          # then start the service
          exec systemctl --user start sway.service
        '';
      })
    ];

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.sway = {
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startsway
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Not starting service, not sure why. Starting in sway config for now.
  #services.redshift = {
  #  enable = true;
  #  package = redshift-wlr;
  #  extraOptions = [
  #    "-m wayland"
  #    "-l 33:-112"
  #    "-g 0.8"
  #     "screen=eDP-1,DP2,HDMI-A-1"
  #     "screen=0,1,2"
  #    ];
  #  temperature = {
  #    day = 5700;
  #    night = 3600;
  #  };
  #};

  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      # kanshi doesn't have an option to specifiy config file yet, so it looks
      # at .config/kanshi/config
      ExecStart = ''
        ${pkgs.kanshi}/bin/kanshi
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };

  programs.waybar.enable = true;
}
