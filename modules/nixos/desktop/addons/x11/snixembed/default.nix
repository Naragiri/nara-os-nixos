{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.desktop.addons.snixembed;
in
{
  options.nos.desktop.addons.snixembed = {
    enable = mkEnableOption "Enable snixembed.";
  };

  config = mkIf cfg.enable { environment.systemPackages = [ pkgs.snixembed ]; };
}
