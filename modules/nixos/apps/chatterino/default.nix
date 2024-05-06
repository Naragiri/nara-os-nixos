{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.chatterino;
in {
  options.nos.apps.chatterino = with types; {
    enable = mkEnableOption "Enable chatterino.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ chatterino2 ];
  };
}
