{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.hardware.network;
in {
  options.nos.hardware.network = with types; {
    enable = mkEnableOption "Enable networking.";
  };

  config = mkIf cfg.enable {
    networking.firewall.enable = true;
    networking.networkmanager.enable = true;
  };
}
