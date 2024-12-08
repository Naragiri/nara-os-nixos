{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.system.boot.plymouth;
in
{
  options.nos.system.boot.plymouth = {
    enable = mkEnableOption "Enable plymouth.";
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.systemd = enabled;
      kernelParams = [
        "quiet"
        "splash"
      ];
      plymouth = enabled;
    };
  };
}
