{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.terminal.kitty;
in {
  options.nos.apps.terminal.kitty = with types; {
    enable = mkEnableOption "Enable kitty.";
    theme = mkNullOpt str null "The theme to apply to kitty.";
    extraConfig = mkOpt (attrsOf str) { } "Extra config to apply to kitty.";
  };

  config = mkIf cfg.enable {
    environment.shellAliases = { "ssh" = "kitten ssh"; };

    nos.home.extraOptions.programs.kitty = {
      inherit (cfg) theme;
      enable = true;
      font = {
        name = "Caskaydia Code Nerd Font";
        size = 16;
      };
      settings = cfg.extraConfig // {
        background_opacity = "0.8";
        confirm_os_window_close = 0;
        enable_audio_bell = "no";
        window_padding_width = 8;
      };
      shellIntegration = {
        enableZshIntegration = config.nos.system.shell.name == "zsh";
      };
    };
  };
}
