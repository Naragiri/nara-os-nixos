{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.librewolf;
in {
  options.nos.apps.librewolf = with types; {
    enable = mkEnableOption "Enable librewolf with custom config.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.programs.librewolf = {
      enable = true;
      settings = {
        "identity.fxaccounts.enabled" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.downloads" = false;
      };
    };
  };
}
