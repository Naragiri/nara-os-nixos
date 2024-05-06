{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.thunar;
in {
  options.nos.apps.thunar = with types; {
    enable = mkEnableOption "Enable thunar.";
  };

  config = mkIf cfg.enable {
    services.gvfs.enable = true;
    services.tumbler.enable = true;

    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ xfconf thunar-volman ];
    };
  };
}
