{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.tools.starship;
in {
  options.nos.tools.starship = with types; {
    enable = mkEnabledOption "Enable starship.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.programs.starship = enabled // {
      enableZshIntegration = config.nos.system.shell.name == "zsh";
      settings = {
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red) ";
        };
      };
    };
  };
}
