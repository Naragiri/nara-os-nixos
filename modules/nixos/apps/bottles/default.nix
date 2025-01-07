{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.bottles;
in
{
  options.nos.apps.bottles = {
    enable = mkEnableOption "Enable bottles.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.bottles ];
  };
}
