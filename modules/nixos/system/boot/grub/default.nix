{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.nos.system.boot.grub;
in
{
  options.nos.system.boot.grub = {
    enable = mkEnableOption "Enable grub.";
    installAsRemovable = mkEnableOption "Enable efiInstallAsRemovable.";
    useOSProber = mkEnableOption "Use os-prober to detect other operating systems.";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        inherit (cfg) useOSProber;
        efiSupport = true;
        efiInstallAsRemovable = cfg.installAsRemovable;
        device = "nodev";
        configurationLimit = 30;
      };
      timeout = mkDefault 5;
    };
  };
}
