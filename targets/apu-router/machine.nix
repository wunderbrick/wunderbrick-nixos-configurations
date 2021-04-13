{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/system-attributes/ssh-strict.nix
  ];

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda"; # or "nodev" for efi only
    };
  };

  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "apu-router";
    firewall = {
      enable = false;
      #allowedTCPPorts = [ 22 ];
      #trustedInterfaces = [ "wlp5s0" ];
    };
    nat = {
      enable = true;
      internalIPs = [ "192.168.11.0/24" ];
      #internalInterfaces = [ "wlp5s0" ];
      externalInterface = "enp1s0";
    };
    useDHCP = false;
    interfaces = {
      enp1s0.useDHCP = true;
      #enp2s0 = {
      #  ipAddress = "192.168.12.1";
      #  prefixLength = 24;
      #};
      #enp3s0 = {
      #  ipAddress = "192.168.13.1";
      #  prefixLength = 24;
      #};
      wlp5s0.ipv4 = {
        addresses = [
          {
            address = "192.168.11.1";
            prefixLength = 24;
          }
        ];
      };
    };
  };

  services = {
    hostapd = {
      enable = true;
      interface = "wlp5s0";
      ssid = "NixOS Cult";
      wpaPassphrase = "toor toor";
      hwMode = "g";
      channel = 10;
    };
    dhcpd4 = {
      enable = true;
      interfaces = [ "wlp5s0" ];
      extraConfig = ''
        option domain-name-servers 1.1.1.1, 8.8.8.8;
        option subnet-mask 255.255.255.0;
        option broadcast-address 192.168.11.255;
        subnet 192.168.11.0 netmask 255.255.255.0 {
          range 192.168.11.100 192.168.11.200;
          option subnet-mask 255.255.255.0;
          option broadcast-address 192.168.11.255;
          option routers 192.168.11.1
        }
      '';
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0hs15hb7LrQoy/8G7w32OOBgO88xUChszdBmrPcQtIggjOr7E+x2zZbZhdNSO22cKrnrKfFleMhPtW5BFThYiEpVla92JDXgBN90Bm1YbTloUYY+DOjyOpirX73/K0gK8hieCC5PcDz6r9hI2GSLMkzWRCCnJnc7pU48JiSe12uzbqAk5+u9psUx9RLUL5G0Vnw/TrU5MQJnIQiN7zrnkvuS4opQIgz+7hp7HZT9gcH2WYlnUsHkN+uoeBMvGiSDRFivUAEIknlIsenW5zHVekrSC3TzsoUb2Pwjhr4Fydy+Pga06M/Nq4UzKMdR1mLdZEGMN63ZOpNeWWekwQ539VNS80Y3cUxSByCFQSWu+FcG2bCu8zdHnrB3Zh/SDbiT651icLvrUpQVEnU3yq3wowlq4Fl/na5BGsNvMKXn00mr5hCLRkIG1zsoP86DhTI9Huiu4xXtfQCVI3VT/b/ax0mYk5kQdBI/3lz0t98REqwQ1ab0YV4x5eMf0XqcSTlrblTK6sZgJwfTkp0Pm1tKqB2+QAD7VS/8Uygz3xPyx+12f+meX4U+FRlIjjcAIbZ6fO23u1skluB7ba7mnxK9sziDDYOfodof4+HJzaVG/NKAOlwuA5YFPPDh0GZERRWB+HIgmZXenEcPRUNeg8kaqBt6+vIy+ljTkMDc/dPjQvQ== awp@nixos-e585"
    ];
  };

  environment.systemPackages = with pkgs; [ wget htop ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  system.stateVersion = "20.09";
}
