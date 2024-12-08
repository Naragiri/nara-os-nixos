{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.tools.direnv;
in
{
  options.nos.tools.direnv = {
    enable = mkEnableOption "Enable direnv.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.programs.direnv = enabled // {
      enableZshIntegration = config.nos.system.shell.name == "zsh";
      nix-direnv = enabled;
    };

    # Shut up direnv.
    environment.sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      DIRENV_WARN_TIMEOUT = "0";
    };
  };
}
