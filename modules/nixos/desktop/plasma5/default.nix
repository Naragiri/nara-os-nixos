{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.desktop.plasma5;
in
{
  options.nos.desktop.plasma5.enable = mkEnableOption "Enable the plasma5 desktop.";

  config = mkIf cfg.enable {
    services.xserver.desktopManager.plasma5.enable = true;
    nos.desktop.addons.sddm.enable = true;
  };
}