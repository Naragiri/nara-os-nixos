{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.desktop.addons.redshift;
in {
  options.nos.desktop.addons.redshift = with types; {
    enable = mkEnableOption "Enable redshift.";
  };

  config = mkIf cfg.enable {
    services.redshift = enabled;

    location = {
      provider = "manual";
      latitude = 40.71427;
      longitude = -74.00597;
    };
  };
}
