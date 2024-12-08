{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.minecraft;
in
{
  options.nos.apps.minecraft = {
    enable = mkEnableOption "Enable minecraft.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.prismlauncher ];
  };
}
