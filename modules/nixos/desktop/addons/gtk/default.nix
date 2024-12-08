{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (lib.nos) mkEnabledOption enabled;
  cfg = config.nos.desktop.addons.gtk;
in
{
  options.nos.desktop.addons.gtk = {
    enable = mkEnableOption "Enable gtk theming.";
    cursorTheme = {
      name = mkOption {
        default = "";
        description = "The name of the cursor.";
        type = types.str;
      };
      package = mkOption {
        default = null;
        description = "The package for the cursor.";
        type = types.nullOr types.package;
      };
      size = mkOption {
        default = 16;
        description = "The size of the cursor.";
        type = types.number;
      };
    };
    iconTheme = {
      name = mkOption {
        default = "";
        description = "The name of the icons for gtk.";
        type = types.str;
      };
      package = mkOption {
        default = null;
        description = "The package to use for the icons for gtk.";
        type = types.nullOr types.package;
      };
    };
    qt.enable = mkEnabledOption "Make qt theming follow gtk theming.";
    theme = {
      name = mkOption {
        default = "";
        description = "The gtk theme name.";
        type = types.str;
      };
      package = mkOption {
        default = null;
        description = "The gtk theme package.";
        type = types.nullOr types.package;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.dconf = enabled;

    nos.home.extraOptions = {
      dconf = enabled // {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      };
      gtk = enabled // {
        cursorTheme = mkIf (cfg.cursorTheme.package != null) {
          inherit (cfg.cursorTheme) name package size;
        };
        iconTheme = mkIf (cfg.iconTheme.package != null) {
          inherit (cfg.iconTheme) name package;
        };
        theme = mkIf (cfg.theme.package != null) {
          inherit (cfg.theme) name package;
        };
      };
      home.pointerCursor = mkIf (cfg.cursorTheme.package != null) {
        inherit (cfg.cursorTheme) name package size;
        gtk = enabled;
        x11 = enabled;
      };
      qt = mkIf cfg.qt.enable enabled // {
        platformTheme.name = "gtk";
      };
    };
  };
}
