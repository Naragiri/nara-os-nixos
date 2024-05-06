{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.steam.rom-manager;
in {
  options.nos.apps.steam.rom-manager = with types; {
    enable = mkEnableOption "Enable steam-rom-manager.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ steam-rom-manager ];
  };
}
