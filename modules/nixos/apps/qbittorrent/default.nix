{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.qbittorrent;
in
{
  options.nos.apps.qbittorrent = {
    enable = mkEnableOption "Enable qbittorrent.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.qbittorrent ];
  };
}
