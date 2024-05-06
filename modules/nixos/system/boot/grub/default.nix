{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.system.boot.grub;
in {
  options.nos.system.boot.grub = {
    enable = mkEnableOption "Enable grub.";
    useOSProber =
      mkEnableOption "Use os-prober to detect other operating systems.";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        efiSupport = true;
        device = "nodev";
        configurationLimit = 30;
        useOSProber = cfg.useOSProber;
      };
      timeout = 5;
    };
  };
}
