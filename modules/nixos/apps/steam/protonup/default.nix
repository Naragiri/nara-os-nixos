{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.steam.protonup;
in
{
  options.nos.apps.steam.protonup = {
    enable = mkEnableOption "Enable protonup.";
  };

  config = mkIf cfg.enable { environment.systemPackages = [ pkgs.protonup ]; };
}
