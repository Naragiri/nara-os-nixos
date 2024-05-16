{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.desktop.addons.gnome-keyring;
in {
  options.nos.desktop.addons.gnome-keyring = with types; {
    enable = mkEnableOption "Enable gnome-keyring.";
  };

  config = mkIf cfg.enable { services.gnome.gnome-keyring = enabled; };
}
