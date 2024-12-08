{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.launchers.lutris;
in
{
  options.nos.apps.launchers.lutris = {
    enable = mkEnableOption "Enable lutris.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.lutris.override {
        extraPkgs = pkgs: [
          pkgs.wineWowPackages.stable
          pkgs.winetricks
        ];
      })
    ];
  };
}
