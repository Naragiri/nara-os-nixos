{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.minecraft;
in {
  options.nos.apps.minecraft = with types; {
    enable = mkEnableOption "Enable minecraft.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [ (prismlauncher.override { jdks = [ jdk8 jdk17 ]; }) ];
  };
}
