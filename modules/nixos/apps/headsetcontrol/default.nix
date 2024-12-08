{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.headsetcontrol;
in
{
  options.nos.apps.headsetcontrol = {
    enable = mkEnableOption "Enable headsetcontrol.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.headsetcontrol ];

    services.udev.packages = [ pkgs.headsetcontrol ];
  };
}
