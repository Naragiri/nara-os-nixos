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
    types
    ;
  inherit (lib.nos) enabled;

  cfg = config.nos.apps.chromium;
in
{
  options.nos.apps.chromium = {
    enable = mkEnableOption "Enable chromium.";
    extensions = mkOption {
      default = [ ];
      description = "A list of extensions to install.";
      type = types.listOf types.attrs;
    };
    makeDefaultBrowser = mkEnableOption "Set as the default browser (mimeapps).";
    package = mkOption {
      default = pkgs.brave;
      description = "The chromium browser package.";
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions = {
      programs.chromium = enabled // {
        inherit (cfg) extensions package;
      };
      xdg.mimeApps.defaultApplications =
        let
          browserName = (builtins.parseDrvName cfg.package.name).name;
          fixedBrowserName = {
            brave = "brave-browser";
          };
          desktopFile = "${fixedBrowserName.${browserName} or browserName}.desktop";
        in
        mkIf cfg.makeDefaultBrowser {
          "x-scheme-handler/http" = "${desktopFile}";
          "x-scheme-handler/https" = "${desktopFile}";
          "x-scheme-handler/chrome" = "${desktopFile}";
          "text/html" = "${desktopFile}";
          "application/x-extension-htm" = "${desktopFile}";
          "application/x-extension-html" = "${desktopFile}";
          "application/x-extension-shtml" = "${desktopFile}";
          "application/xhtml+xml" = "${desktopFile}";
          "application/x-extension-xhtml" = "${desktopFile}";
          "application/x-extension-xht" = "${desktopFile}";
        };
    };
  };
}
