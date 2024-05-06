{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.module;
in {
  options.nos.module = with types; {
    enable = mkEnableOption "Enable module.";
  };

  config = mkIf cfg.enable { };
}
