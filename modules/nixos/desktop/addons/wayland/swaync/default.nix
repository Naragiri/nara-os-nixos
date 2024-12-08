{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.desktop.addons.swaync;
in
{
  options.nos.desktop.addons.swaync = {
    enable = mkEnableOption "Enable swaync.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.services.swaync = enabled;
  };
}
