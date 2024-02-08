{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.apps.web.vivaldi;
in
{
  options.nos.apps.web.vivaldi.enable = mkEnableOption "Enable the vivaldi web browser.";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vivaldi
    ];
  };
}