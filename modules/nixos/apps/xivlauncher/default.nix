{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.xivlauncher;
in {
  options.nos.apps.xivlauncher = with types; {
    enable = mkEnableOption "Enable xivlauncher.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ xivlauncher ];

    nos.services.syncthing.extraFolders.".xlcore" = {
      path = "/home/${config.nos.user.name}/.xlcore";
      devices = [ "hades" "zeus" ];
    };
  };
}
