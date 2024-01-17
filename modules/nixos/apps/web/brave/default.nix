{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.apps.web.brave;
in
{
  options.nos.apps.web.brave.enable = mkEnableOption "Enable the brave web browser.";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ brave ];
  };
}