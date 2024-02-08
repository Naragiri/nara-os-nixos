{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.apps.games.common;
in
{
  options.nos.apps.games.common = {
    launchers.enable = mkEnableOption "Enable module.";
  };

  config = {
    environment.systemPackages = with pkgs; optionals (cfg.launchers.enable) [
      lutris heroic
    ];
  };
}