{ config, pkgs, ... }:

{
  fonts = {
    #fontconfig.enable = false;
    #enableDefaultFonts = true;
    fonts = with pkgs; [ ubuntu_font_family iosevka terminus font-awesome ];
  };
}
