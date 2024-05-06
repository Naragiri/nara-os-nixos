{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.tools.direnv;
in {
  options.nos.tools.direnv = with types; {
    enable = mkEnableOption "Enable direnv.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.programs.direnv = enabled // {
      enableZshIntegration = config.nos.system.shell.name == "zsh";
      nix-direnv = enabled;
    };

    # Shut up direnv.
    environment.sessionVariables.DIRENV_LOG_FORMAT = "";
  };
}
