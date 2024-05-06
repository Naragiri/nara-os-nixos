{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.qbittorrent;
in {
  options.nos.apps.qbittorrent = with types; {
    enable = mkEnableOption "Enable qbittorrent.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ qbittorrent ];
  };
}
