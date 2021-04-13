{ config, pkgs, ... }:

{
  virtualisation = {
    #virtualbox = {
    #  guest = {
    #    enable = true;
    #    x11 = true;
    #  };
    #  host = {
    #    enable = true;
    #    addNetworkInterface = true;
    #    enableHardening = true;
    #  };
    #};
    #docker = {
    #  enable = false;
    #  liveRestore = false;
    #};
    anbox = { enable = true; };
  };
}
