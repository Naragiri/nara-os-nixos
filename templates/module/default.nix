{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.module;
in
{
  options.nos.module.enable = mkEnableOption "Enable module.";

  config = mkIf cfg.enable {
  };
}