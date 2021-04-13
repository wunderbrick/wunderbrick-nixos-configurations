{ config, pkgs, ... }:

with pkgs;
let
  hostname = "thinkpad-x1";
  userGroups = [ "wheel" "networkmanager" "dialout" "audio" ];
  eww = callPackage ../../shared/packages/eww/default.nix { };
in {
  imports = [
    ./hardware-configuration.nix
    ../../shared/system-attributes/location.nix
    ../../shared/system-attributes/hardware.nix
    ../../shared/system-attributes/networking.nix
    ../../shared/system-attributes/programs.nix
    ../../shared/system-attributes/security.nix
    ../../shared/system-attributes/xserver.nix
    ../../shared/system-attributes/mpd.nix
    ../../shared/system-attributes/fonts.nix
    ../../shared/system-attributes/i3.nix
    ../../shared/system-attributes/ssh-strict.nix
  ];

  boot = {
    initrd.secrets = { "keyfile0.bin" = "/etc/secrets/initrd/keyfile0.bin"; };
    loader = {
      grub = {
        device = "/dev/sda"; # (for BIOS systems only)
        enableCryptodisk = true;
      };
    };
    initrd = {
      luks = {
        devices = {
          root = {
            device = "/dev/disk/by-uuid/707fc695-cbfd-4b10-ab41-71350ba13c91";
            preLVM = true;
            keyFile = "/keyfile0.bin";
          };
        };
        mitigateDMAAttacks = true;
      };
    };
    kernelPackages = linuxPackages_hardened;
  };

  fileSystems."/mnt/truenas" = {
    device = "192.168.10.143:/mnt/mainpool/mainset/library";
    fsType = "nfs";
    options = [ "rw" "x-systemd.automount" "noauto" ];
  };

  networking = {
    hostName = hostname;
    firewall = { allowedTCPPorts = [ 22 ]; };
  };

  hardware = {
    pulseaudio.enable = true;
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  sound.enable = true;

  users = {
    users = {
      awp = {
        isNormalUser = true;
        extraGroups = userGroups;
      };
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCxejxxPoOT3tCYpd74WXnY4r58kCr41EnZMsNGnsDESy4iuLSxG8N322PfpnU+/6KfVUonT2JZ1B93QXvRnwb+dOU1MOy1kxJtTJ1i+HLRW7OR+AaqF/LM+fTLR6tMZJzqCDnF94fyrS0QY/o32TXsb4Qy52YFkYxQCzXRy9iHxPetqc9FSZaOtT/C4dstLU8uxrOPUSlhtkqTGsmM5M2xXi0hUZBp6IxjxC/T6tMTPxjYlhDDBDnK5IglQtTHhBAj9i0+ho76e2U/e7cjiqVRDmJipeB8OYBbkijTGCYr5OV/3V1lKA4cxH9TEg79aRWGyvL/S3Rmlhp+vGXm5VQdyBzzNMI+Syfo3e08GF8iIzXy5IoprfRg/anIjHbcW4HkxC0rRur4na2vf9SCoSmptN3C+TgLrybSC1h3B5nBNcIKCgWfFn3NxJkdHD8mx254+P42+v4U1rz8f6UZoeuQHC4cQIHTGr+Wfu4UhvAVzf68ZZDaPZ97itHf78TPjawjxKJVY3lcevdz/y0QdqFOVZX0F8Jyf6jbOGmxgfQ3sH7Vowd15dJM6jzxFM+oL7vQ6CBp8KQiE+8/BpdkzZVr1oijES7/h4tT8iJ16VMwwKrssTmIOBTY2JHOu/UoqjUtEqRbbdqEfOdeaSW119PPP2/oDhrBvnhaEJgtJdyhQ== awp@nixos-e585"
        ];
      };
    };
  };

  nixpkgs.config = { allowUnfree = true; };

  environment.systemPackages = [
    microcodeIntel
    kodi
    ungoogled-chromium
    arandr
    redshift
    dolphin
    gnome3.nautilus
    gnome3.gvfs
    mpd
    alacritty
    nixops
    git
    wget
    feh
    compton
    htop
    pavucontrol
    eww
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
