{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.apps.web.librewolf;
in
{
  options.nos.apps.web.librewolf.enable = mkEnableOption "Enable the librewolf web browser.";

  config = mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [ librewolf ];

    # home.file.".librewolf/librewolf.overrides.cfg".text = ''
    #   defaultPref("identity.fxaccounts.enabled", true);
    #   defaultPref("privacy.clearOnShutdown.history", false);
    #   defaultPref("privacy.clearOnShutdown.downloads", false);
    # '';

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