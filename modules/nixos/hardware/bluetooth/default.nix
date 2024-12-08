{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.hardware.bluetooth;
in
{
  options.nos.hardware.bluetooth = {
    enable = mkEnableOption "Enable bluetooth.";
  };

  config = mkIf cfg.enable {
    services.blueman = enabled;

    hardware.bluetooth = enabled // {
      powerOnBoot = true;
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
