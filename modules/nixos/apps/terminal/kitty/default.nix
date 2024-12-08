{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.nos.apps.terminal.kitty;
in
{
  options.nos.apps.terminal.kitty = {
    enable = mkEnableOption "Enable kitty.";
    themeFile = mkOption {
      default = null;
      description = "The theme to apply to kitty.";
      type = types.nullOr types.str;
    };
    extraConfig = mkOption {
      default = { };
      description = "Extra config to apply to kitty.";
      type = types.attrsOf types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.shellAliases = {
      "ssh" = "kitten ssh";
    };

    nos.home.extraOptions.programs.kitty = {
      inherit (cfg) themeFile;
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
