{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.system.security.doas;
in {
  options.nos.system.security.doas = with types; {
    enable = mkEnableOption "Enable doas and remove sudo.";
  };

  config = mkIf cfg.enable {
    environment.shellAliases = { sudo = "doas"; };

    security = {
      sudo.enable = false;

      doas = {
        enable = true;
        extraRules = [{
          users = [ config.nos.user.name ];
          keepEnv = true;
          persist = true;
        }];
      };
    };
  };
}
