{ config, pkgs, ... }:

let
  sshPublicKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaoxwVSPrjdkkGWAdnuRrpF7zyHG+kQTv+ssnjfO/T49SDmzawwAwVnW9hcr22XeFhv7EPUcTCTR19f+J98jgwYmZZYTsf5ud/crdRSl+G3Ku+uMC3EKXTp9bB3KtmSm5vA2LMt9hdMdW4DVabT/z3Y1NLIotHquUlayqb94t83Vk8qFlK5Eia20SxVE8ec9YqmtibFJYjH6f5yEldx5c/ADXQpmH/yXgH3JVaaoLyzv8NIXVx4gQQYnJ+PVsVaHjuW2pQmTHJVK2ETQ49VeF1LBQ0yzLrqhDoaKX6EyWncbztzpd/qRI3Aur03Y7OfwBOYXHdF8pMQNWD5PxyofrN40WPS49lxxQmsq/0vvA7t+gm/PDMPP6A5pitVEDdNlHyLUzgAGIasZ8sq6KIHD1z7KAIgZ2LhVi8AsY50+yjeNoQZnVFuloC6HFg1RlwZIBAuPzER4IH8FTTTE7FIdv3b7U3EpBZ7HA1bHUrz4dxwbkv6UPU58z/dbGfq1sDQj5vu+ok3jtuPfnVCd55Vjaq1tF7QGxTKljETvQNRlFFEv4Tnnx4U3ip2iW8kEwKBpkzNRcD56YW5KMZOeY2rG4cNyd0XwaiyiRf0mSTdRk8XOD8LeBlHlp18bu5cl56y8aO2hYV8/wPzrBPsD2F6C7hmnSbgUuR6VV15jywxShIpw== awp@nixos-e585"
  ];
in {
  disabledModules = [ "services/torrent/transmission.nix" ];

  imports = [
    ./hardware-configuration.nix
    ./transmission.nix # Removed the chown and chmod for the destination dirs because they weren't working with the NFS share.
    ../../shared/system-attributes/ssh-strict.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.disable_ipv6" = 1;
      "net.ipv6.conf.default.disable_ipv6" = 1;
      "net.ipv6.conf.lo.disable_ipv6" = 1;
      "net.ipv6.conf.eth0.disable_ipv6" = 1;
      };
  };

  fileSystems."/mnt/truenas" = {
    device = "192.168.2.11:/mnt/mainpool/mainset/library";
    fsType = "nfs";
    options = [ "rw" "x-systemd.automount" "noauto" ];
  };

  networking = {
    hostName = "truenas-transmission-vm";
    useDHCP = false;
    interfaces.enp0s4.useDHCP = true;
    firewall = {
      allowedTCPPorts = [
        22
      ];
      extraCommands = ''
      #iptables -A OUTPUT -j ACCEPT -m owner --gid-owner openvpn
      #iptables -A OUTPUT -j ACCEPT -o tun+

      iptables -A nixos-fw -p tcp --source 192.168.1.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp --source 192.168.2.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp --source 192.168.3.0/24 -j nixos-fw-accept

      iptables -A nixos-fw -p udp --source 192.168.1.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --source 192.168.2.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --source 192.168.3.0/24 -j nixos-fw-accept

      #iptables -P OUTPUT DROP
      #iptables -P INPUT DROP
      '';
      extraStopCommands = ''
      #iptables -D OUTPUT -j ACCEPT -m owner --gid-owner openvpn | true
      #iptables -D OUTPUT -j ACCEPT -o tun+

      iptables -D nixos-fw -p tcp --source 192.168.1.0/24 -j nixos-fw-accept
      iptables -D nixos-fw -p tcp --source 192.168.2.0/24 -j nixos-fw-accept
      iptables -D nixos-fw -p tcp --source 192.168.3.0/24 -j nixos-fw-accept

      iptables -D nixos-fw -p udp --source 192.168.1.0/24 -j nixos-fw-accept
      iptables -D nixos-fw -p udp --source 192.168.2.0/24 -j nixos-fw-accept
      iptables -D nixos-fw -p udp --source 192.168.3.0/24 -j nixos-fw-accept

      #iptables -D OUTPUT DROP
      #iptables -D INPUT DROP
      #'';
    };
  };

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  users = {
    users = {
      awp = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = sshPublicKeys;
      };
      root = { openssh.authorizedKeys.keys = sshPublicKeys; };
      openvpn = {
        isSystemUser = true;
        extraGroups = [ "openvpn" ];
      };
    };
    groups = {
      openvpn = {};
    };
  };

  environment.systemPackages = with pkgs; [ wget curl htop protonvpn-cli ];

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  age.secrets = {
    protonvpn-auth-user-pass = {
      file = ../../secrets/protonvpn-auth-user-pass.age;
    };
  };

  services = {
    openssh.hostKeys = options.services.openssh.hostKeys.default ++ [
        {
          type = "ed25519";
          path = /home/awp/.ssh/id_ed25519; # Requires --impure flag with Flakes
        }
      ];
    };
    openvpn.servers = {
      ny-29-p2p = {
        config = import ./us-ny-29.protonvpn.com.udp.ovpn.nix;
        up = "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
        down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
      };
    };
    transmission = {
      enable = true;
      settings = {
        rpc-whitelist = "127.0.0.1,192.168.*.*";
        rpc-bind-address = "0.0.0.0";
        download-dir = "/mnt/truenas/vm-torrents";
        incomplete-dir = "/mnt/truenas/vm-torrents/.incomplete";
        incomplete-dir-enabled = true;
        watch-dir = "/mnt/truenas/vm-torrents/.torrent-files";
        watch-dir-enabled = true;
        start-added-torrents = false;
      };
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  system.stateVersion = "20.09";
}
