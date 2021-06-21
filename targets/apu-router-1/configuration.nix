{ config, pkgs, options, ... }:

{
  imports = [
    ./hardware-configuration.nix
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
    hostName = "apu-router-1";
    firewall = {
      enable = true;
      allowPing = true;
      trustedInterfaces = [ "wlp5s0" "enp2s0" "enp3s0" ];
    };
    nat = {
      enable = true;
      internalIPs = [ "192.168.1.0/24" "192.168.2.0/24" "192.168.3.0/24" ];
      externalInterface = "enp1s0";
    };
    useDHCP = false;
    interfaces = {
      wlp5s0 = {
        ipv4.addresses = [
          { address = "192.168.1.1";
            prefixLength = 24;
          }
        ];
      };
      enp1s0 = {
        useDHCP = true;
      };
      enp2s0 = {
        ipv4.addresses = [
          { address = "192.168.2.1";
            prefixLength = 24;
          }
        ];
      };
      enp3s0 = {
        ipv4.addresses = [
          { address = "192.168.3.1";
            prefixLength = 24;
          }
        ];
      };
    };
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
    hostapd = {
      enable = true;
      interface = "wlp5s0";
      ssid = "Serenity";
      hwMode = "g";
      channel = 10;
      extraConfig = ''
        rsn_pairwise=CCMP
        ieee80211n=1
        ht_capab=[SHORT-GI-40][HT40+][HT40-][DSSS_CCK-40]
        wmm_enabled=1
        wpa_key_mgmt=WPA-PSK
        wpa_psk=56c03456212675151217823d71054f66a360d1dcffeb4b3272c6432c136cc8aa
      '';
    };

    dnsmasq = {
      enable = true;
      extraConfig = ''
        domain=lan
        interface=wlp5s0
        interface=enp2s0
        interface=enp3s0
        bind-interfaces
        dhcp-range=192.168.1.10,192.168.1.254,24h
        dhcp-range=192.168.2.10,192.168.2.254,24h
        dhcp-range=192.168.3.10,192.168.3.254,24h
        dhcp-host=rpi4-0,192.168.1.11
        dhcp-host=truenas,192.168.2.11
        dhcp-host=truenas-transmission-vm,192.168.2.12
        dhcp-host=truenas-irc-client,192.168.2.13
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

  system.stateVersion = "21.05";
}
