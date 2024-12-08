{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.launchers.heroic;
in
{
  options.nos.apps.launchers.heroic = {
    enable = mkEnableOption "Enable heroic games launcher.";
  };

  config = mkIf cfg.enable { environment.systemPackages = [ pkgs.heroic ]; };
}
