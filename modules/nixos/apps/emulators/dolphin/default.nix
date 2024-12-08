{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.emulators.dolphin;
in
{
  options.nos.apps.emulators.dolphin = {
    enable = mkEnableOption "Enable dolphin.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.dolphin-emu ];
  };
}
