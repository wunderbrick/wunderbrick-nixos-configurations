{ config, pkgs, ... }:

{
  services = {
    upower.enable = true;
    lorri.enable = true;
    printing.enable = false;
  };
}
