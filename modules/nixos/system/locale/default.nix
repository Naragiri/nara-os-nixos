{ lib, config, ... }:
with lib;
{
  config = {
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "America/New_York";

    console = {
      keyMap = mkForce "us";
    };

    services.xserver = {
      layout = "us";
    };
  };
}