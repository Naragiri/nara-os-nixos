{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.desktop.addons.gnome-keyring;
in
{
  options.nos.desktop.addons.gnome-keyring = {
    enable = mkEnableOption "Enable gnome-keyring.";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring = enabled;
    security.pam.services.gdm-password.enableGnomeKeyring = true;

    environment.variables.XDG_RUNTIME_DIR = "/run/user/${
      toString config.users.users.${config.nos.user.name}.uid
    }";
  };
}
