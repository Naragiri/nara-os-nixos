{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.system.battery;
in
{
  options.nos.system.battery = {
    enable = mkEnableOption "Enable battery.";
  };

  config = mkIf cfg.enable {
    services.upower = enabled;
    # powerManagement.powertop = enabled;
    environment.systemPackages = [ pkgs.powertop ];
  };
}
