{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.module;
in
{
  options.nos.module = {
    enable = mkEnableOption "Enable module.";
  };

  config = mkIf cfg.enable { };
}
