{ config, pkgs, ... }:

{
  qt5 = {
    enable = true;
    platformTheme = "gtk2";
    style = "plastique";
  };
}
