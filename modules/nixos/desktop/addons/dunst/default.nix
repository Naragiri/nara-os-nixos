{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.desktop.addons.dunst;
in
{
  options.nos.desktop.addons.dunst = {
    enable = mkEnableOption "Enable dunst.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.dunst
      pkgs.libnotify
    ];
  };
}
