{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.desktop.addons.redshift;
in
{
  options.nos.desktop.addons.redshift = {
    enable = mkEnableOption "Enable redshift.";
  };

  config = mkIf cfg.enable {
    services.redshift = enabled;
    location.provider = "geoclue2";
  };
}
