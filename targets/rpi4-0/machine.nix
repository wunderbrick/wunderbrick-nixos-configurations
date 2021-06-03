{ config, pkgs, lib, ... }:

let
  user = "awp";
  password = "just a placeholder";
  hostname = "rpi4-0";
  pubKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCX+02jq2ocfNBIhSdwpoUleICaycOX63ng/vGg7BQkLQ5liipWnB3Sk6AzqFPztxfmVsCBIIcQOssCCWSXrzH6y9VTpa6CvL1A0EGBtC2XZJnTtbojxa9ierPCsonCMFkiwugv3Gxztuf+vrQgPcKawzPNnuZ7PrDyy/V14Y8sS3N5lif0I9nDMOTO4uMh3w6QbVeEJO8LkZkWRfAdrJdDhV2OmXoKliUErOXS5TPJZL/KFRXZzPTLs0fh0ZPLVYcwpq26n0TXBr1B9m1++IhgJFCeSu/Py9qvWKEDC7/YoxeUik5rZyBLn2GpJtmDE3JAgGwR+Z8Aw7ln4+9JLkYvO+cl3Bz2kOyclij1e1d8H3O7Ny1zYmzRW9obILBxqyGRb7ud9oiFKMrdJr0+L1bS+TPVYA38Ma1dHY0F9DZO2fq31xo1bySv13pJmWUJd/lSzUPPYXm6ZjVmJ0Iaes46zjDhcpSDN9rgcqIpwaj8WLcuRgFHV+GBjhxbRRTshk/7EXmB3u6fctRgXXnxlx379yhsKMx1TvXH5I1BlGMQOW9PnJHUb+wmqW9p8p2K0ADqEKx45OY6qK54IHq6tcbq6mn1LYwL8GXIkZEcbqLZ7IblhU3HUc0tyuiSnBkmLP2kt55vXzJwGnIYKaiwMY9k5jkPLXOaarCquSZq+ahjw== awp@thinkpad-e585";
in {
  imports = ["${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz" }/raspberry-pi/4"];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  environment.systemPackages = with pkgs; [ htop wget curl ];

  services.openssh.enable = true;

  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      password = password;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [ pubKey ];
    };
    users.root = {
      password = password;
      openssh.authorizedKeys.keys = [ pubKey ];
    };
  };

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.i3.enable = true;
  };

  hardware.pulseaudio.enable = true;
}