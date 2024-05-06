{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.tools.qmk;
in {
  options.nos.tools.qmk = with types; {
    enable = mkEnableOption "Enable qmk and via(l).";
  };

  config = mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;

    environment.systemPackages = with pkgs; [ qmk via vial ];

    services.udev.packages = [ pkgs.via pkgs.vial ];
  };
}
