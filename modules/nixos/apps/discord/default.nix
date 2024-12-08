{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    readFile
    types
    ;
  cfg = config.nos.apps.discord;
in
{
  options.nos.apps.discord = {
    enable = mkEnableOption "Enable discord.";
    package = mkOption {
      default = pkgs.vesktop;
      description = "The package for discord.";
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    nos.cli-apps.wallust.templates = mkIf config.nos.cli-apps.wallust.addons.vencord.enable {
      "vencord-theme.css" =
        let
          file = "discord-wallust-beta";
          folderName = if cfg.package == pkgs.vesktop then "vesktop" else "Vencord";
        in
        {
          text = readFile "${pkgs.nos.discord-wal-theme}/${file}.css";
          target = "/home/${config.nos.user.name}/.config/${folderName}/themes/${file}.css";
        };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
