{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.modding.nexus-mod-manager;
in
{
  options.nos.apps.modding.nexus-mod-manager = {
    enable = mkEnableOption "Enable nexus mod manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.nexusmods-app-unfree ];
  };
}
