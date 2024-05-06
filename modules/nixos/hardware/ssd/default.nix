{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.hardware.ssd;
in {
  options.nos.hardware.ssd = with types; {
    enable = mkEnableOption "Enable ssd.";
  };

  config = mkIf cfg.enable { 
    services.fstrim.enable = true;
  };
}
