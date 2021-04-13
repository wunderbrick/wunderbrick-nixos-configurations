{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      layout = "us";
    };
    redshift = {
      extraOptions = [ "-m randr screen=HDMI1" ];
      enable = true;
      temperature = {
        day = 3600;
        night = 3600;
      };
    };
    compton = {
      enable = true;
      backend = "glx";
      settings = {
        glx-no-stencil = true;
        paint-on-overlay = true;
        vsync = "opengl-swc";
      };
    };
  };
}
