{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.emulators.rpcs3;
in
{
  options.nos.apps.emulators.rpcs3 = {
    enable = mkEnableOption "Enable rpcs3.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.rpcs3
    ];
  };
}
