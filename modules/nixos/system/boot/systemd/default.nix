{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.system.boot.systemd;
in {
  options.nos.system.boot.systemd = with types; {
    enable = mkEnableOption "Enable systemd boot.";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 30;
      };
      timeout = 5;
    };
  };
}
