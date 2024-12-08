{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled disabled;
  cfg = config.nos.system.security.doas;
in
{
  options.nos.system.security.doas = {
    enable = mkEnableOption "Enable doas and remove sudo.";
  };

  config = mkIf cfg.enable {
    environment.shellAliases = {
      sudo = "doas";
    };

    environment.systemPackages = [ pkgs.doas-sudo-shim ];

    security = {
      sudo = disabled;

      doas = enabled // {
        extraRules = [
          {
            users = [ config.nos.user.name ];
            keepEnv = true;
            persist = true;
          }
        ];
      };
    };
  };
}
