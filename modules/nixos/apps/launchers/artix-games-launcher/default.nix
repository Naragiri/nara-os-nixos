{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.launchers.artix-games-launcher;
in
{
  options.nos.apps.launchers.artix-games-launcher = {
    enable = mkEnableOption "Enable Artix Games launcher.";
  };

  config = mkIf cfg.enable { environment.systemPackages = [ pkgs.nos.artix-games-launcher ]; };
}
