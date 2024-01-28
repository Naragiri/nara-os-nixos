{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.system.hardware.bluetooth;
in
{
  options.nos.system.hardware.bluetooth.enable = mkEnableOption "Enable the bluetooth module.";

  config = mkIf cfg.enable {
    services.blueman.enable = true;

    hardware.bluetooth = {
      enable = true;
      # powerOnBoot = true;
      settings = {
        General = {
          FastConnectable = true;
          JustWorksRepairing = "always";
          Privacy = "device";
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
  };
}