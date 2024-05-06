{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.desktop.addons.polkit-gnome;
in {
  options.nos.desktop.addons.polkit-gnome = with types; {
    enable = mkEnableOption "Enable polkit-gnome.";
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;
    systemd = {
      user.services.polkit-gnome = {
        description = "polkit-gnome";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart =
            "${pkgs.polkit_gnome}/bin/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
