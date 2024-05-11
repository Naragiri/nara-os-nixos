{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.cli-apps.snixembed;
in {
  options.nos.cli-apps.snixembed = with types; {
    enable = mkEnableOption "Enable snixembed.";
  };

  config = mkIf cfg.enable { 
    environment.systemPackages = with pkgs; [
      snixembed
    ];
  };
}
