{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.brave;
in {
  options.nos.apps.brave = with types; {
    enable = mkEnableOption "Enable brave.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ brave ]; };
}
