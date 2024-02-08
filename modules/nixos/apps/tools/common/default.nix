{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.apps.tools.common;
in
{
  options.nos.apps.tools.common.enable = mkEnableOption "Enable the common tools module.";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rsync
      gptfdisk
      zip
      unzip
      man
      wget
      btop
      killall
    ];
  };
}