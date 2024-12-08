{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    getExe
    ;
  inherit (lib.nos.vscode) mkVscodeModule;

  cfg = config.nos.apps.vscode;

  # Copied from https://github.com/kubukoz/nix-config/blob/ad845b8dfd96ae53b1cb6be92687942e55641912/vscode/default.nix
  vscodeModule = mkVscodeModule {
    inherit (cfg) package;
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    userSettings = import ./settings.nix;
    keybindings = import ./keybindings.nix { inherit lib; };
  };
in
{
  imports = [
    vscodeModule
    ./extensions.nix
    ./theme.nix
  ];

  options.nos.apps.vscode = {
    enable = mkEnableOption "Enable vscode with custom config.";
    package = mkOption {
      default = pkgs.vscodium;
      description = "The vscode package.";
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions = {
      xdg.mimeApps.defaultApplications =
        let
          packageName = (builtins.parseDrvName cfg.package.name).name;
          fixedEditorName = {
            vscodium = "codium";
          };
          desktopFile = "${fixedEditorName.${packageName} or packageName}.desktop";
        in
        {
          "text/plain" = "${desktopFile}";
        };
    };

    environment.shellAliases = {
      "c" = "${getExe cfg.package} .";
    };
  };
}
