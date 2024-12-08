{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.hardware.network;
in
{
  options.nos.hardware.network = {
    enable = mkEnableOption "Enable networking.";
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = enabled;
      networkmanager = enabled;
      nameservers = [ "192.168.10.14" ];
    };

    environment.systemPackages = [ pkgs.networkmanagerapplet ];
  };
}
