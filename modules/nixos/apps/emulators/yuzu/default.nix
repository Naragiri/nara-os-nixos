{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.emulators.yuzu;
in
{
  options.nos.apps.emulators.yuzu = {
    enable = mkEnableOption "Enable yuzu.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      # pkgs.yuzu-mainline
      # pkgs.yuzu-early-access
    ];
  };
}
