{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.discord;
in {
  options.nos.apps.discord = with types; {
    enable = mkEnableOption "Enable discord.";
    wallustTheme.enable = mkEnableOption "Enable wallust vencord theme.";
  };

  config = mkIf cfg.enable {
    nos.cli-apps.wallust.templates = mkIf (cfg.wallustTheme.enable) {
      "vencord-theme.css" = {
        new_engine = false;
        text = readFile "${pkgs.nos.discord-wal-theme}/discord-wallust.css";
        target =
          "/home/${config.nos.user.name}/.config/Vencord/themes/discord-wallust.css";
      };
    };

    environment.systemPackages = with pkgs;
      [
        # (discord.override {
        #   withOpenASAR = true;
        #   withVencord = true;
        # })
        vesktop
      ];
  };
}
