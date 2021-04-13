{ config, pkgs, ... }:

with pkgs;
let
  packages = import ../shared/packages/pkgs-list.nix { inherit pkgs unstable; };

  packageList = with packages; typewriter;
in {
  imports = [ # Include the results of the hardware scan.
    ../hardware-configuration.nix
    ../shared/system-attributes/location.nix
    ../shared/system-attributes/hardware.nix
    ../shared/system-attributes/systemd.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "thinkpad-t400"; # Define your hostname.

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = packageList;

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.windowManager.jwm.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

  networking.networkmanager.enable = true;

  location = {
    provider = "manual";
    latitude = 40.7;
    longitude = -74.0;
  };

  services.redshift = {
    enable = true;
    temperature = {
      day = 5500;
      night = 3600;
    };
  };

  users.users.awp = {
    isNormalUser = true;
    home = "/home/awp";
    description = "awp";
    extraGroups = [ "wheel" "networkmanager" ];
  };

}
