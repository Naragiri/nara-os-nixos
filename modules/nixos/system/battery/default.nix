{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.system.battery;
in {
  options.nos.system.battery = with types; {
    enable = mkEnableOption "Enable battery.";
  };

  config = mkIf cfg.enable {
    services.upower = enabled;
    # powerManagement.powertop.enable = true;
    environment.systemPackages = with pkgs; [ powertop ];
  };
}
