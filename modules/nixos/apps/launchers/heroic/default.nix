{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.launchers.heroic;
in {
  options.nos.apps.launchers.heroic = with types; {
    enable = mkEnableOption "Enable heroic games launcher.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ heroic ]; };
}
