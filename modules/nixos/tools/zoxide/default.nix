{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.tools.zoxide;
in {
  options.nos.tools.zoxide = with types; {
    enable = mkEnableOption "Enable zoxide.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.programs.zoxide = enabled // {
      enableZshIntegration = config.nos.system.shell.name == "zsh";
    };
  };
}
