{ config, pkgs, ... }:

{
  users = {
    users = {
      awp = {
        isNormalUser = true;
        home = "/home/awp";
        shell =
          pkgs.elvish; # problems with Elvish server, for now hacky work around means starting Elvish from i3 config with alacritty -e
        description = "awp";
        extraGroups = [
          "wheel"
          "networkmanager"
          "dialout"
          "adbusers"
          "vboxusers"
          "docker"
          "jackaudio"
          "audio"
        ];
      };
    };
  };
}
