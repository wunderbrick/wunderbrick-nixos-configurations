{ pkgs, ... }:

with pkgs; rec {

  #uHaskellPackages = unstable.haskellPackages;

  nixExtras = [ nixops nixfmt patchelf direnv niv cachix nix-prefetch-git gnumake ];

  haskellStuff = [
    ghc
    stack
    cabal2nix
    cabal-install
  ];

  elixirStuff = [
    elixir
    gleam
    inotifyTools
    gcc # for argon2_elixir
    gnumake # for argon2_elixir
  ];

  arduinoTools = [ arduino arduino-cli python3 ];

  devDatabase = [ postgresql ];

  docker = [ docker docker-compose docker-proxy docker-machine ];

  sharedDevTools = [
    # Git
    git
    gitg
    kdiff3
    cloc
    wireshark
    nmap
    peek # screen recorder
    wget
    curl
  ];

  editors = [
    kakoune
    kak-lsp # language server plugin
    ghcid
    binutils.bintools

    #vscode
    vscodium # MIT License, no MS branding, no telemetry # https://github.com/VSCodium/vscodium

    xfce.mousepad
    ghostwriter # Markdown editor
  ];

  terminalsEtc = [
    # TERMINALS & ACCESSORIES
    alacritty
    xfce.terminal
    tmux
    elvish
  ];

  utils = [
    spectre-meltdown-checker
    exfat
    ntfs3g
    parted
    gparted
    polkit
    gnome3.file-roller
    zip
    unzip
    p7zip
    file
    lsof
    usbutils
    jmtpfs # for manually mounting Android with MTP
    psensor
    htop
    brightnessctl # Screen Brightness
    pciutils
    exa # colored 'ls'
    scrot
    neofetch
  ];

  audioAndVideo = [
    pavucontrol
    paprefs # Pulse Audio Preferences

    vlc
    cmus
    mpc_cli
  ];

  desktopConveniences = [
    dolphin
    gnome3.nautilus
    gnome3.sushi
    gnome3.gvfs
    xfce.thunar
    android-file-transfer
  ];

  iconThemes = [
    gnome2.gnome_icon_theme
    pantheon.elementary-icon-theme
    arc-icon-theme
    gnome3.adwaita-icon-theme
    kdeFrameworks.kiconthemes
    lxqt.lxqt-themes
    numix-icon-theme
    numix-icon-theme-circle
    paper-icon-theme
    papirus-icon-theme
  ];

  gnomeStuff = [
    gnome3.gnome-tweaks
    gnome3.gnome-shell-extensions
    arc-theme
    theme-vertex
    zuki-themes
    libwnck
    libwnck3 # not sure which one PutWindows extensions actually needs
  ];

  browsers = [
    tor-browser-bundle-bin
    firefox
    ungoogled-chromium
  ];

  games = [
    ## Libre licenses
    nethack
    nethack-x11
    nethack-qt

    chocolateDoom
    gzdoom

    openmw

    quakespasm
  ];

  chat = [
    dino
    gajim

    hexchat
    weechat
  ];

  office = [ zathura qpdfview calibre libreoffice ];

  photos = [ feh viu krita gimp inkscape aseprite-unfree ];

  securityPrivacy = [ macchanger networkmanager-openvpn openvpn networkmanagerapplet gnupg protonvpn-cli ];

  torrents = [ transmission-gtk ];

  typewriter = [
    wget
    curl
    htop
    kakoune
    git
    focuswriter
    redshift
    xfce.thunar
    xfce.xfce4-terminal
    exfat
    ntfs3g
  ];

  misc = [
    plan9port
  ];
}
