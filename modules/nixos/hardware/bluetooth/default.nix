{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.hardware.bluetooth;
in {
  options.nos.hardware.bluetooth = with types; {
    enable = mkEnableOption "Enable bluetooth.";
  };

  config = mkIf cfg.enable {
    services.blueman.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          FastConnectable = true;
          JustWorksRepairing = "always";
          Privacy = "device";
        };
        Policy = { AutoEnable = true; };
      };
    };
  };
}
