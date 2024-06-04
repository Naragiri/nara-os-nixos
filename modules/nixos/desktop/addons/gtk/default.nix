{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.desktop.addons.gtk;
in {
  options.nos.desktop.addons.gtk = with types; {
    enable = mkEnableOption "Enable gtk theming.";
    cursorTheme = {
      name = mkStrOpt "" "The name of the cursor.";
      package = mkNullOpt package null "The package for the cursor.";
      size = mkNumOpt 16 "The size of the cursor.";
    };
    iconTheme = {
      name = mkStrOpt "" "The name of the icons for gtk.";
      package =
        mkNullOpt package null "The package to use for the icons for gtk.";
    };
    qt.enable = mkEnabledOption "Make qt theming follow gtk theming.";
    theme = {
      name = mkStrOpt "" "The gtk theme name.";
      package = mkNullOpt package null "The gtk theme package.";
    };
  };

  config = mkIf cfg.enable {
    programs.dconf.enable = true;

    nos.home.extraOptions = {
      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
        };
      };
      gtk = {
        enable = true;
        cursorTheme = { inherit (cfg.cursorTheme) name package size; };
        iconTheme = { inherit (cfg.iconTheme) name package; };
        theme = { inherit (cfg.theme) name package; };
      };
      home.pointerCursor = mkIf (cfg.cursorTheme.package != null) {
        inherit (cfg.cursorTheme) name package size;
        gtk = enabled;
        x11 = enabled;
      };
      qt = mkIf (cfg.qt.enable) {
        enable = true;
        platformTheme.name = "gtk";
      };
    };
  };
}
