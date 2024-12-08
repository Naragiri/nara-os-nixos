{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.nos) mkEnabledOption;
  cfg = config.nos.cli-apps.nos;
in
{
  options.nos.cli-apps.nos = {
    enable = mkEnabledOption "Enable nos.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.nos.nos ];
  };
}
