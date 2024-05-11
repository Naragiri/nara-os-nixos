{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.system.boot.plymouth;
in {
  options.nos.system.boot.plymouth = with types; {
    enable = mkEnableOption "Enable plymouth.";
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.systemd.enable = true;
      kernelParams = [ "quiet" "splash" ];
      plymouth.enable = true;
    };
  };
}
