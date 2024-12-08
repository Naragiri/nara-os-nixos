{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.hardware.ssd;
in
{
  options.nos.hardware.ssd = {
    enable = mkEnableOption "Enable ssd.";
  };

  config = mkIf cfg.enable { services.fstrim = enabled; };
}
