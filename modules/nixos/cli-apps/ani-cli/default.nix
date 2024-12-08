{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.cli-apps.ani-cli;
in
{
  options.nos.cli-apps.ani-cli = {
    enable = mkEnableOption "Enable ani-cli.";
  };

  config = mkIf cfg.enable { environment.systemPackages = [ pkgs.ani-cli ]; };
}
