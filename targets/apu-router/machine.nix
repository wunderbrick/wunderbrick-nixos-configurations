{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/system-attributes/ssh-strict.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "apu-router"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

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

  networking.firewall.allowedTCPPorts = [ 22 ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

  system.stateVersion = "20.09";
}
