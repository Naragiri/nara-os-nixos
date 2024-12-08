{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.nos.cli-apps.fastfetch;
in
{
  options.nos.cli-apps.fastfetch = {
    enable = mkEnableOption "Enable fastfetch.";
  };

  config = mkIf cfg.enable {
    environment.shellAliases = {
      "nf" = "${getExe pkgs.fastfetch}";
      "ff" = "${getExe pkgs.fastfetch}";
    };
    nos.home.configFile."fastfetch/config.jsonc".text = builtins.readFile ./config.jsonc;
    nos.home.file.".local/share/fastfetch/logos/snowflake.png".source = ./snowflake.png;
  };
}
