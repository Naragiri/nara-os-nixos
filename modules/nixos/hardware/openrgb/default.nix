{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  no-rgb = pkgs.writeScriptBin "no-rgb" ''
    #!/bin/sh
    NUM_DEVICES=$(${pkgs.openrgb}/bin/openrgb --noautoconnect --list-devices | grep -E '^[0-9]+: ' | wc -l)

    for i in $(seq 0 $(($NUM_DEVICES - 1))); do
      ${pkgs.openrgb}/bin/openrgb --noautoconnect --device $i --mode static --color 000000
    done
  '';
  cfg = config.nos.hardware.openrgb;
in
{
  options.nos.hardware.openrgb = {
    enable = mkEnableOption "Enable the openrgb module.";
    no-rgb.enable = mkEnableOption "Automatically turn off rgb via systemd service.";
  };

  config = mkIf cfg.enable {

    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };

    hardware.i2c.enable = true;

    systemd.services.no-rgb = mkIf (cfg.no-rgb.enable) {
      description = "no-rgb";
      serviceConfig = {
        ExecStart = "${no-rgb}/bin/no-rgb";
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}