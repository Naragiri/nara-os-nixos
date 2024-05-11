{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.steam.protonup;
in {
  options.nos.apps.steam.protonup = with types; {
    enable = mkEnableOption "Enable protonup.";
  };

  config = mkIf cfg.enable { 
    environment.systemPackages = with pkgs; [
      protonup
    ];
  };
}
