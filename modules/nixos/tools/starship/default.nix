{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.nos) mkEnabledOption enabled;
  cfg = config.nos.tools.starship;
in
{
  options.nos.tools.starship = {
    enable = mkEnabledOption "Enable starship.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.programs.starship = enabled // {
      settings = {
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red) ";
        };
      };
    };
  };
}
