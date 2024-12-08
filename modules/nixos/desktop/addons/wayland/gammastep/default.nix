{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.desktop.addons.gammastep;
in
{
  options.nos.desktop.addons.gammastep = {
    enable = mkEnableOption "Enable gammastep.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.services.gammastep = enabled // {
      dawnTime = "6:00-7:45";
      duskTime = "18:35-20:15";
      provider = "geoclue2";
    };
  };
}
