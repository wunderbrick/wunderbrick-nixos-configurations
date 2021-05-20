{ config, pkgs, ... }:

{
  services = {
    gnome3.at-spi2-core.enable = true;
  };
}