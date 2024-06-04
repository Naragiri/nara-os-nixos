{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.desktop.addons.sddm;
in {
  options.nos.desktop.addons.sddm = with types; {
    enable = mkEnableOption "Enable sddm.";
    theme = {
      enable = mkEnableOption "Enable sddm theme.";
      name = mkNullOpt str null "The name of the sddm theme.";
      package = mkNullOpt package null "The package of the sddm theme";
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = mkMerge [
      enabled
      { autoNumlock = true; }
      (mkIf cfg.theme.enable { theme = cfg.theme.name; })
    ];

    security.pam.services.sddm.enableGnomeKeyring =
      config.nos.desktop.addons.gnome-keyring.enable;

    environment.systemPackages = with pkgs;
      [
        libsForQt5.qt5.qtgraphicaleffects
        libsForQt5.qt5.qtquickcontrols2
        libsForQt5.qt5.qtsvg
      ] ++ optionals (cfg.theme.enable) [ cfg.theme.package ];
  };
}
