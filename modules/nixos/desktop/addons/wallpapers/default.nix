{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let
  cfg = config.nos.desktop.addons.wallpapers;
  inherit (pkgs.nos) nos-wallpapers;
in {
  options.nos.desktop.addons.wallpapers = with types; {
    enable = mkEnableOption "Enable wallpapers.";
  };

  config = mkIf cfg.enable {
    nos.home.file.wallpapers = {
      source = "${pkgs.nos.nos-wallpapers}";
      target = "/home/${config.nos.user.name}/Pictures/Wallpapers";
      recursive = true;
    };
  };
}
