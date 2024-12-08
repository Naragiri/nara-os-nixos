{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.tools.qmk;
in
{
  options.nos.tools.qmk = {
    enable = mkEnableOption "Enable qmk and via(l).";
  };

  config = mkIf cfg.enable {
    hardware.keyboard.qmk = enabled;

    environment.systemPackages = [
      pkgs.via
      pkgs.vial
    ];

    services.udev.packages = [
      pkgs.via
      pkgs.vial
    ];
  };
}
