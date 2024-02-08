{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.apps.social.discord;
in
{
  options.nos.apps.social.discord.enable = mkEnableOption "Enable the discord module.";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (discord.override {
        withOpenASAR = true;
      })
      xwaylandvideobridge
    ];
  };
}