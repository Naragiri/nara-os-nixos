{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.services.flatpak;
in
{
  options.nos.services.flatpak = {
    enable = mkEnableOption "Enable flatpak.";
  };

  config = mkIf cfg.enable { services.flatpak = enabled; };
}
