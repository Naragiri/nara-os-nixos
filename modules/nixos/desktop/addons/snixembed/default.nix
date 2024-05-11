{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.desktop.addons.snixembed;
in {
  options.nos.desktop.addons.snixembed = with types; {
    enable = mkEnableOption "Enable snixembed.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ snixembed ]; };
}
