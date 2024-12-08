{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.apps.librewolf;
in
{
  options.nos.apps.librewolf = {
    enable = mkEnableOption "Enable librewolf with custom config.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.programs.librewolf = enabled // {
      settings = {
        "identity.fxaccounts.enabled" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.downloads" = false;
      };
    };
  };
}
