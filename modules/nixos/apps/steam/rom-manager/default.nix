{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.steam.rom-manager;
in
{
  options.nos.apps.steam.rom-manager = {
    enable = mkEnableOption "Enable steam-rom-manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.steam-rom-manager ];
  };
}
