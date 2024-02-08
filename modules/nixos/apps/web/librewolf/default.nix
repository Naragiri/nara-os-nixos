{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.apps.web.librewolf;
in
{
  options.nos.apps.web.librewolf.enable = mkEnableOption "Enable the librewolf web browser.";

  config = mkIf cfg.enable {
    home.extraOptions.programs.librewolf = {
      enable = true;
      settings = {
        "identity.fxaccounts.enabled" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.downloads" = false;
      };
    };
  };
}