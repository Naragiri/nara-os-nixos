{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.cli-apps.yazi;
in
{
  options.nos.cli-apps.yazi = {
    enable = mkEnableOption "Enable yazi.";
  };

  config = mkIf cfg.enable { environment.systemPackages = [ pkgs.yazi ]; };
}
