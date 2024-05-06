{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.emulators.dolphin;
in {
  options.nos.apps.emulators.dolphin = with types; {
    enable = mkEnableOption "Enable dolphin.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dolphin-emu ];
  };
}
