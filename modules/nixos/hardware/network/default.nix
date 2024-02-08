{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.hardware.network;
in
{
  options.nos.hardware.network.enable = mkEnableOption "Enable networking on the device.";

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}