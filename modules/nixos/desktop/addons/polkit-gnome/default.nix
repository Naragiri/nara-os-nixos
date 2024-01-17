{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.desktop.addons.polkit-gnome;
in
{
  options.nos.desktop.addons.polkit-gnome.enable = mkEnableOption "Enable the polkit-gnome module.";

  config = mkIf cfg.enable {
    security.polkit.enable = true;
    systemd = {
      user.services.lxpolkit = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
      };
    };

    environment.systemPackages = with pkgs; [
      polkit_gnome
    ];
  };
}