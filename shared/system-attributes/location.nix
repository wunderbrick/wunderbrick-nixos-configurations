{ config, pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "America/New_York";

  # Redshift
  location = {
    provider = "manual";
    latitude = 40.7;
    longitude = -74.0;
  };
}
