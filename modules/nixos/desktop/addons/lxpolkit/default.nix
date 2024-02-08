{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.desktop.addons.lxpolkit;
in
{
  options.nos.desktop.addons.lxpolkit.enable = mkEnableOption "Enable the lxpolkit module.";

  config = mkIf cfg.enable {
    security.polkit.enable = true;
    systemd = {
      user.services.lxpolkit = {
        description = "lxpolkit";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.lxsession}/bin/lxpolkit";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
      };
    };

    environment.systemPackages = with pkgs; [
      lxsession
    ];
  };
}