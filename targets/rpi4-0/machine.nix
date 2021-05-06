{ config, pkgs, lib, ... }:

{
 # This configuration worked on 09-03-2021 nixos-unstable @ commit 102eb68ceec
 # The image used https://hydra.nixos.org/build/134720986

  imports = [
    #./hardware-configuration.nix # relevant options already in this file
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
        "8250.nr_uarts=1"
        "console=ttyAMA0,115200"
        "console=tty1"
        # Some gui programs need this
        "cma=128M"
    ];
  };

  boot.loader.raspberryPi = {
    enable = true;
    version = 4;
  };
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;

  #hardware.opengl = {
  #  enable = true;
  #  setLdLibraryPath = true;
  #  package = pkgs.mesa_drivers;
  #};
  #hardware.deviceTree = {
  #  kernelPackage = pkgs.linux_rpi4;
  #  overlays = [ "${pkgs.device-tree_rpi.overlays}/vc4-fkms-v3d.dtbo" ];
  #};

  hardware.pulseaudio.enable = true;
  sound.enable = true;

  #services.xserver = {
  #  enable = true;
  #  displayManager.gdm = { enable = true; };
  #  windowManager.i3 = { enable = true; };
  #  videoDrivers = [ "modesetting" ];
  #};
  boot.loader.raspberryPi.firmwareConfig = ''
    gpu_mem=192
    dtparam=audio=on
  '';

  networking = {
    hostName = "rpi4-0"; # Define your hostname.
    wireless = {
      enable = true;
      extraConfig =
        ''
        network={
            ssid="VeryFunctional"
            psk="duck flash single plasma hero 19"
        }
        '';
    };
    firewall = { allowedTCPPorts = [ 22 80 443 9091 ]; };
  };

  environment.systemPackages = with pkgs; [
    #kodi
    #ungoogled-chromium
    #arandr
    #redshift
    #dolphin
    #gnome3.nautilus
    #gnome3.gvfs
    alacritty
    wget
    #feh
    #compton
    htop
    #pavucontrol
   ];

  users = {
    mutableUsers = false;
    users.root = {
      password = "just a placeholder";
      openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCX+02jq2ocfNBIhSdwpoUleICaycOX63ng/vGg7BQkLQ5liipWnB3Sk6AzqFPztxfmVsCBIIcQOssCCWSXrzH6y9VTpa6CvL1A0EGBtC2XZJnTtbojxa9ierPCsonCMFkiwugv3Gxztuf+vrQgPcKawzPNnuZ7PrDyy/V14Y8sS3N5lif0I9nDMOTO4uMh3w6QbVeEJO8LkZkWRfAdrJdDhV2OmXoKliUErOXS5TPJZL/KFRXZzPTLs0fh0ZPLVYcwpq26n0TXBr1B9m1++IhgJFCeSu/Py9qvWKEDC7/YoxeUik5rZyBLn2GpJtmDE3JAgGwR+Z8Aw7ln4+9JLkYvO+cl3Bz2kOyclij1e1d8H3O7Ny1zYmzRW9obILBxqyGRb7ud9oiFKMrdJr0+L1bS+TPVYA38Ma1dHY0F9DZO2fq31xo1bySv13pJmWUJd/lSzUPPYXm6ZjVmJ0Iaes46zjDhcpSDN9rgcqIpwaj8WLcuRgFHV+GBjhxbRRTshk/7EXmB3u6fctRgXXnxlx379yhsKMx1TvXH5I1BlGMQOW9PnJHUb+wmqW9p8p2K0ADqEKx45OY6qK54IHq6tcbq6mn1LYwL8GXIkZEcbqLZ7IblhU3HUc0tyuiSnBkmLP2kt55vXzJwGnIYKaiwMY9k5jkPLXOaarCquSZq+ahjw== awp@thinkpad-e585"
        ];
    };
  };

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  # Assuming this is installed on top of the disk image.
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    crossSystem = {
      config = "aarch64-unknown-linux-gnu";
      system = "aarch64-linux";
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";
  system.stateVersion = "20.09";
  swapDevices = [ { device = "/swapfile"; size = 2048; } ];

}