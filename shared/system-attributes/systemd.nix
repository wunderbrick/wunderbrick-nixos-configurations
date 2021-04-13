{ config, pkgs, ... }:

{
  systemd = { services = { upower = { enable = true; }; }; };
}
