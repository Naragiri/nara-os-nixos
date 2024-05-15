{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.easyeffects;
in {
  options.nos.apps.easyeffects = with types; {
    enable = mkEnableOption "Enable easyeffects.";
    preset = mkNullOpt str null "The preset to use.";
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [
    #   easyeffects
    # ];
    nos.home.extraOptions.services.easyeffects = {
      enable = true;
      preset = cfg.preset;
    };
  };
}
