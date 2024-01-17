{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.system.hardware.network;
in
{
  options.nos.system.hardware.network.enable = mkEnableOption "Enable networking on the device.";

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}