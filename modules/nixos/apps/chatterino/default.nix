{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.chatterino;
in
{
  options.nos.apps.chatterino = {
    enable = mkEnableOption "Enable chatterino.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.chatterino2 ];
  };
}
