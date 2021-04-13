{ config, pkgs, ... }:

{
  services = {
    mpd = {
      enable = true;
      network.listenAddress = "any";
      musicDirectory =
        "nfs://192.168.10.143/mnt/mainpool/mainset/library/music/acceptable-maybe";
      playlistDirectory = "/home/awp/Music/mpd-playlists";
      extraConfig = ''
        audio_output {
            type            "httpd"
            name            "HTTP Stream"
            encoder         "flac"
            port            "8000"
            mixer_type      "software"
            format          "44100:16:2"
        }

        log_level           "verbose"
      '';
    };
    ympd.enable = true;
  };
}
