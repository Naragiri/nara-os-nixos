{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.tools.zoxide;
in
{
  options.nos.tools.zoxide = {
    enable = mkEnableOption "Enable zoxide.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.programs.zoxide = enabled // {
      enableZshIntegration = config.nos.system.shell.name == "zsh";
    };
  };
}
