{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.system.boot.systemd;
in
{
  options.nos.system.boot.systemd = {
    enable = mkEnableOption "Enable systemd boot.";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = enabled // {
        editor = false;
        configurationLimit = 30;
      };
      timeout = 5;
    };
  };
}
