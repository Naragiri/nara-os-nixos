{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (lib.nos) enabled;
  cfg = config.nos.desktop.addons.greetd;
in
{
  options.nos.desktop.addons.greetd = {
    enable = mkEnableOption "Enable greetd.";
  };

  config = mkIf cfg.enable {
    services.greetd = enabled // {
      vt = 1;
      settings = {
        default_session =
          let
            defaultSession =
              if config.nos.desktop.hyprland.enable then "Hyprland" else throw "No default session for greetd.";
          in
          {
            user = config.nos.user.name;
            command = "${getExe pkgs.greetd.tuigreet} --time --cmd ${defaultSession}";
          };
      };
    };

    security.pam.services.greetd.enableGnomeKeyring = config.nos.desktop.addons.gnome-keyring.enable;
  };
}
