{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.module;
in
{
  options.nos.module.enable = mkEnableOption "Enable module.";

  config = mkIf cfg.enable {
  };
}