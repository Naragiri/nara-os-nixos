{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.emulators.citra;
in
{
  options.nos.apps.emulators.citra = {
    enable = mkEnableOption "Enable citra.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      # pkgs.citra-nightly
      # pkgs.citra-canary
    ];
  };
}
