{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.spotify;
in {
  options.nos.apps.spotify = with types; {
    enable = mkEnableOption "Enable spotify.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ spotify ]; };
}
