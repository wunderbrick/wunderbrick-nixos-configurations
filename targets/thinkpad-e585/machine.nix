{ config, pkgs, ... }:

with pkgs;
let
  user = "awp";
  hostName = "thinkpad-e585";
  allPkgs = import ../../shared/packages/pkgs-list.nix { inherit pkgs; };
  sway =
    import ../../shared/system-attributes/sway.nix { inherit config pkgs; };
  sshConfig = import ../../shared/ssh_config.nix;

  selectedPkgs = with allPkgs;
    nixExtras ++ haskellStuff ++ arduinoTools ++ devDatabase ++ sharedDevTools
    ++ editors ++ terminalsEtc ++ utils ++ audioAndVideo ++ desktopConveniences
    ++ gnomeStuff ++ accesibility ++ browsers ++ games ++ chat ++ office ++ photos
    ++ securityPrivacy ++ torrents ++ iconThemes ++ misc;
in {
  imports = [
    ./hardware-configuration.nix
    ../../shared/system-attributes/location.nix
    ../../shared/system-attributes/hardware.nix
    ../../shared/system-attributes/networking.nix
    ../../shared/system-attributes/fonts.nix
    ../../shared/system-attributes/services.nix
    ../../shared/system-attributes/programs.nix
    ../../shared/system-attributes/security.nix
    ../../shared/system-attributes/gnome3.nix
    ../../shared/system-attributes/xserver.nix
    ../../shared/system-attributes/databases.nix
    ../../shared/system-attributes/accessibility.nix
  ] ++ [ sway ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    initrd = {
      luks = {
        devices = {
          root = {
            device =
              "/dev/disk/by-uuid/6152b385-f52e-48ed-9088-caf109e126e0"; # UUID for /dev/nvme01np2;
            preLVM = true;
            allowDiscards = true;
          };
        };
        mitigateDMAAttacks = true;
      };
    };
    kernelPackages = linuxPackages_latest; #_hardened;
    kernelParams = [ "quiet acpi_osi=Linux" "acpi_backlight=native" ];
    binfmt.emulatedSystems = [ "aarch64-linux" ]; # https://nixos.wiki/wiki/NixOS_on_ARM#Compiling_through_QEMU # Build rpi on x86
  };

  fileSystems."/mnt/truenas" = {
    device = "192.168.2.11:/mnt/mainpool/mainset/library";
    fsType = "nfs";
    options = [ "rw" "x-systemd.automount" "noauto" ];
  };

  networking = { hostName = hostName; };

  hardware = {
    bluetooth = {
      enable = true;
      config = { General = { Enable = "Source,Sink,Media,Socket"; }; };
    };
    pulseaudio = {
      enable = true;
      # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
      # Only the full build has Bluetooth support, so it must be selected here.
      package = pkgs.pulseaudioFull;
      extraModules = [ pkgs.pulseaudio-modules-bt ];

    };
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  sound.enable = true;

  services.blueman.enable = true;

  xdg.icons.enable = true;
  gtk.iconCache.enable = true;

  nixpkgs.config = { allowUnfree = true; };

  environment.systemPackages = [ microcodeAmd google-chrome ] ++ selectedPkgs;

  users = {
    users = {
      "${user}" = {
        isNormalUser = true;
        home = "/home/${user}";
        shell = pkgs.elvish;
        description = "awp";
        extraGroups = [
          "wheel"
          "networkmanager"
          "dialout"
          "adbusers"
          "vboxusers"
          "docker"
          "audio"
        ];
        packages = [ ];
      };
    };
  };

  programs.ssh.extraConfig = sshConfig;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

  nix = {
    useSandbox = true;
    trustedUsers = [ "root" "${user}" ]; # for IHP
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    # Obsidian Reflex-FRP
    binaryCaches =
      [ "https://nixcache.reflex-frp.org" "https://miso-haskell.cachix.org" ];
    binaryCachePublicKeys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "miso-haskell.cachix.org-1:6N2DooyFlZOHUfJtAx1Q09H0P5XXYzoxxQYiwn6W1e8="
    ];
  };
}
