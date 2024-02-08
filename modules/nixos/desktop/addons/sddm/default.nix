{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.desktop.addons.sddm;
in
{
  options.nos.desktop.addons.sddm.enable = mkEnableOption "Enable the sddm display manager.";

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.sddm.enable = true;
    };
  };
}