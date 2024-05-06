{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.services.flatpak;
in {
  options.nos.services.flatpak = with types; {
    enable = mkEnableOption "Enable flatpak.";
  };

  config = mkIf cfg.enable { services.flatpak.enable = true; };
}
