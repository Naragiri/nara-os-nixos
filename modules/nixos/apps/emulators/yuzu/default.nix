{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.emulators.yuzu;
in {
  options.nos.apps.emulators.yuzu = with types; {
    enable = mkEnableOption "Enable yuzu.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ yuzu-mainline yuzu-early-access ];
  };
}
