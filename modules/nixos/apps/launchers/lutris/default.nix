{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.launchers.lutris;
in {
  options.nos.apps.launchers.lutris = with types; {
    enable = mkEnableOption "Enable lutris.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        (lutris.override {
          extraPkgs = pkgs: [
            # List package dependencies here
            wineWowPackages.stable
            winetricks
          ];
        })
      ];
  };
}
