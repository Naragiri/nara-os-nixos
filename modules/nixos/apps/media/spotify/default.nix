{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.apps.media.spotify;
in
{
  options.nos.apps.media.spotify.enable = mkEnableOption "Enable the spotify module.";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ spotify ];
  };
}