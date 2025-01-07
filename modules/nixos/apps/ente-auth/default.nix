{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.ente-auth;
in
{
  options.nos.apps.ente-auth = {
    enable = mkEnableOption "Enable ente-auth.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ente-auth ];
  };
}
