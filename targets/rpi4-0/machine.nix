{ config, pkgs, lib, ... }:

{
 # This configuration worked on 09-03-2021 nixos-unstable @ commit 102eb68ceec
 # The image used https://hydra.nixos.org/build/134720986

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

  hardware.opengl = {
    enable = true;
    setLdLibraryPath = true;
    package = pkgs.mesa_drivers;
  };
  hardware.deviceTree = {
    kernelPackage = pkgs.linux_rpi4;
    overlays = [ "${pkgs.device-tree_rpi.overlays}/vc4-fkms-v3d.dtbo" ];
  };

  hardware.pulseaudio.enable = true;
  sound.enable = true;

  services.xserver = {
    enable = true;
    displayManager.gdm = { enable = true; };
    windowManager.i3 = { enable = true; };
    videoDrivers = [ "modesetting" ];
  };
  boot.loader.raspberryPi.firmwareConfig = ''
    gpu_mem=192
    dtparam=audio=on
  '';

  networking = {
    hostName = "rpi4-0"; # Define your hostname.
    networkmanager = {
      enable = true;
    };
    firewall = { allowedTCPPorts = [ 22 ]; };
  };

  environment.systemPackages = with pkgs; [
    kodi
    ungoogled-chromium
    arandr
    redshift
    dolphin
    gnome3.nautilus
    gnome3.gvfs
    mpd
    alacritty
    wget
    feh
    compton
    htop
    pavucontrol
   ];

  users = {
    mutableUsers = false;
    users.root = {
      password = "just a placeholder";
      openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCxejxxPoOT3tCYpd74WXnY4r58kCr41EnZMsNGnsDESy4iuLSxG8N322PfpnU+/6KfVUonT2JZ1B93QXvRnwb+dOU1MOy1kxJtTJ1i+HLRW7OR+AaqF/LM+fTLR6tMZJzqCDnF94fyrS0QY/o32TXsb4Qy52YFkYxQCzXRy9iHxPetqc9FSZaOtT/C4dstLU8uxrOPUSlhtkqTGsmM5M2xXi0hUZBp6IxjxC/T6tMTPxjYlhDDBDnK5IglQtTHhBAj9i0+ho76e2U/e7cjiqVRDmJipeB8OYBbkijTGCYr5OV/3V1lKA4cxH9TEg79aRWGyvL/S3Rmlhp+vGXm5VQdyBzzNMI+Syfo3e08GF8iIzXy5IoprfRg/anIjHbcW4HkxC0rRur4na2vf9SCoSmptN3C+TgLrybSC1h3B5nBNcIKCgWfFn3NxJkdHD8mx254+P42+v4U1rz8f6UZoeuQHC4cQIHTGr+Wfu4UhvAVzf68ZZDaPZ97itHf78TPjawjxKJVY3lcevdz/y0QdqFOVZX0F8Jyf6jbOGmxgfQ3sH7Vowd15dJM6jzxFM+oL7vQ6CBp8KQiE+8/BpdkzZVr1oijES7/h4tT8iJ16VMwwKrssTmIOBTY2JHOu/UoqjUtEqRbbdqEfOdeaSW119PPP2/oDhrBvnhaEJgtJdyhQ== awp@nixos-e585"
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

  nixpkgs.config = {
    allowUnfree = true;
  };
  powerManagement.cpuFreqGovernor = "ondemand";
  system.stateVersion = "20.09";
  swapDevices = [ { device = "/swapfile"; size = 2048; } ];
}