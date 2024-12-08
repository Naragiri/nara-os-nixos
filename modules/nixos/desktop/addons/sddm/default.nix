{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    types
    optionals
    ;
  inherit (lib.nos) enabled;
  cfg = config.nos.desktop.addons.sddm;
in
{
  options.nos.desktop.addons.sddm = {
    enable = mkEnableOption "Enable sddm.";
    theme = {
      enable = mkEnableOption "Enable sddm theme.";
      name = mkOption {
        default = null;
        description = "The name of the sddm theme.";
        type = types.nullOr types.str;
      };
      package = mkOption {
        default = null;
        description = "The package of the sddm theme";
        type = types.nullOr types.package;
      };
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = mkMerge [
      enabled
      { autoNumlock = true; }
      (mkIf cfg.theme.enable { theme = cfg.theme.name; })
    ];

    security.pam.services.sddm.enableGnomeKeyring = config.nos.desktop.addons.gnome-keyring.enable;

    environment.systemPackages =
      with pkgs.libsForQt5.qt5;
      [
        qtgraphicaleffects
        qtquickcontrols2
        qtsvg
      ]
      ++ optionals cfg.theme.enable [ cfg.theme.package ];
  };
}
