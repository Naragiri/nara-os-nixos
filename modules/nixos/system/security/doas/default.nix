{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.system.security.doas;
in
{
  options.nos.system.security.doas.enable = mkEnableOption "Enable doas instead of sudo.";

  config = mkIf cfg.enable {
    environment.shellAliases = { sudo = "doas"; };

    security = {
      sudo.enable = false;

      doas = {
        enable = true;
        extraRules = [{
          groups = [ "wheel" ];
          keepEnv = true;
          persist = true;
        }];
      };
    };
  };
}