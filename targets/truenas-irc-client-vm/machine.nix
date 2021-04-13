{ config, pkgs, ... }:

let
  keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQClnwhxSWX/6Uk7/A3egYvabOEDD7PQi6cwGLlimTHO3yjZ6J/p+FTV1tKFMukEv3sNK1m6bDhXNH28Su2XJDI1yb3W4AFFYJs4GTclFUbQ00QwYUKBg8uLxuHvyVHZ7IsJVVwe3RLH2Mtw57m9ZQHHNm9JnjNCgATpzfnbHUuxOlE6bxpm0nl+EKJrWSkoH01quD+U0/Fe76CJsU9kO7Yjo+Wj46E1UhbxFP0+gsqKbWjbTjvyVHeEkk9fRWW6MtwdsRJ9CrA4fWhRvuibLp6zJRZe5dwaP4y3pM+/3jRf91mu8WCbj0PHihc2yuw1qjSbOOrmZ1M0kOpmqbCVaDYp0fI01ZLOTCENA7TCYSxoCqiBn3JTs6s5TxaFLli3rsJ5ML2lpg5D+Q/imbPZuE9GCV3ypiLEFuShsU+0L0EajLhtRFDgIISNCoRnJI+V8XWgi1EJ8e93Dc52gDp6V8J9+jeHdRItncrmfwQ3qufuhbwKMfgI7wKh0ersNJX12L1h0HFnWyf/H+AZ0Wa3i+Fekn4glmQhSa62JHpVHkU2uyTQhxYrgx9Wyj5PS0l8oS0T8TPTQawoWhaJ+RgSVShMon5kohmpFFaU/qJudTKtHCI0zrWfIItw/zQZUCakCgMbpTe/AsIBreHZwoixHZlzwkne0UdPx1qxcAZTnF6X7w== awp@nixos-e585"
  ];
in {
  imports = [
    ./hardware-configuration.nix
    ../../shared/system-attributes/ssh-strict.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixos-irc-client";
    useDHCP = false;
    interfaces.enp0s4.useDHCP = true;
    firewall.allowedTCPPorts = [ 22 ];
  };

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  users.users = {
    awp = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = keys;
    };
    root = { openssh.authorizedKeys.keys = keys; };
  };

  environment.systemPackages = with pkgs; [ wget curl htop irssi tmux ];

  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  system.stateVersion = "20.09";
}
