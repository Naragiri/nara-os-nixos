{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.system.boot.grub;
in
{
  options.nos.system.boot.grub = {
    enable = mkEnableOption "Enable grub as the bootloader.";
    useOSProber = mkEnableOption "Use OS prober to detect other operating systems.";
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        timeout = 5;
        grub = {
          efiSupport = true;
          device = "nodev";
          configurationLimit = 30;
          useOSProber = cfg.useOSProber;
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };
    };
  };
}
