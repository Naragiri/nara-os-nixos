{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.emulators.citra;
in {
  options.nos.apps.emulators.citra = with types; {
    enable = mkEnableOption "Enable citra.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ citra-nightly citra-canary ];
  };
}
