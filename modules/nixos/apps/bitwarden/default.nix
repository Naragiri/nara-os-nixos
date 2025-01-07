{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.bitwarden;
in
{
  options.nos.apps.bitwarden = {
    enable = mkEnableOption "Enable bitwarden.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.bitwarden ];
  };
}
