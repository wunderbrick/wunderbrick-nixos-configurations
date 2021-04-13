{ config, pkgs, ... }:

{
  networking = {
    networkmanager = { enable = true; };
    enableIPv6 = false;
    # This silly stuff is because of some systemd bug that affects captive portals IIRC
    #extraHosts =
    #  "172.31.98.1 aruba.odyssys.net"; # Default gateway at Starbucks, find with ip route after connecting to access point
    # nameservers = ["8.8.8.8" "172.31.98.1"]; # For Starbucks
    firewall.enable = true;
  };
}
