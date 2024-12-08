{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.launchers.xivlauncher;
in
{
  options.nos.apps.launchers.xivlauncher = {
    enable = mkEnableOption "Enable xivlauncher.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nos.xivlauncher-rb
    ];

    nos.services.syncthing.extraFolders.".xlcore" = {
      path = "/home/${config.nos.user.name}/.xlcore";
      devices = [
        "hades"
        "zeus"
      ];
    };
  };
}
