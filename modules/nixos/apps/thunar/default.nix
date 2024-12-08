{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.thunar;
in
{
  options.nos.apps.thunar = {
    enable = mkEnableOption "Enable thunar.";
  };

  config = mkIf cfg.enable {
    services.gvfs.enable = true;
    services.tumbler.enable = true;

    programs.thunar = {
      enable = true;
      plugins = [
        pkgs.xfce.xfconf
        pkgs.xfce.thunar-volman
      ];
    };
  };
}
