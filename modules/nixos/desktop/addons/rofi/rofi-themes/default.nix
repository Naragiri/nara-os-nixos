{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    types
    replaceStrings
    readFile
    elem
    ;
  cfg = config.nos.desktop.addons.rofi.rofi-themes;

  colorschemes = [
    "adapta"
    "arc"
    "black"
    "catppuccin"
    "cyberpunk"
    "dracula"
    "everforest"
    "gruvbox"
    "lovelace"
    "navy"
    "nord"
    "onedark"
    "paper"
    "solarized"
    "tokyonight"
    "wallust"
    "yousai"
  ];

  createRofiTheme =
    let
      colorscheme =
        if cfg.colorscheme == "wallust" then
          ''
            * {
                background:     {{color0}};
                background-alt: {{color0}};
                foreground:     {{foreground}};
                selected:       {{color4}};
                active:         {{color6}};
                urgent:         {{color1}};
            }
          ''
        else
          cfg.colorscheme.result;

    in
    rasiPath: ''
      ${colorscheme}

      element alternate.normal {
        background-color:            @background;
        foreground-color:            @foreground;
      }

      ${replaceStrings [ "@import" ] [ "// @import" ] (readFile rasiPath)}
    '';

  launcherTheme = "${pkgs.nos.rofi-themes}/files/launchers/type-${toString cfg.launcher.type}/style-${toString cfg.launcher.style}.rasi";
in
{
  options.nos.desktop.addons.rofi.rofi-themes = {
    enable = mkEnableOption "Enable rofi.";
    colorscheme = mkOption {
      apply =
        value:
        if value != null && value != "" && elem value colorschemes then
          {
            inherit value;
            result = "@import \"${pkgs.nos.rofi-themes}/files/colors/${value}.rasi\"";
          }
        else
          {
            inherit value;
            result =
              let
                inherit (inputs.nix-colors.colorschemes.${value}) palette;
              in
              ''
                * {
                    background:     #${palette.base00}FF;
                    background-alt: #${palette.base01}FF;
                    foreground:     #${palette.base06}FF;
                    selected:       #${palette.base0D}FF;
                    active:         #${palette.base0B}FF;
                    urgent:         #${palette.base08}FF;
                }
              '';
          };
      default = "catppuccin-mocha";
      type = types.str;
      description = "The colorscheme to apply to rofi.";
    };
    launcher = {
      enable = mkEnableOption "Enable the app-launcher theme.";
      type = mkOption {
        default = 2;
        type = types.number;
        description = "The index for the app-launcher \"type\".";
      };
      style = mkOption {
        default = 2;
        type = types.number;
        description = "The index for the app-launcher \"style\".";
      };
    };
    # TODO: Reimplement?
    # powerMenu = {
    #   enable = mkEnableOption "Enable the powerMenu theme.";
    #   type = mkOption {
    #     default = 2;
    #     type = types.number;
    #     description = "The index for the powerMenu \"type\".";
    #   };
    #   script = mkOption {
    #     default = appLauncherScript;
    #     type = types.oneOf [
    #       types.str
    #       types.lines
    #       types.package
    #     ];
    #     description = "The script to run the powerMenu.";
    #   };
    #   style = mkOption {
    #     default = 9;
    #     type = types.number;
    #     description = "The index for the powerMenu \"style\".";
    #   };
    # };
  };

  config = mkMerge [
    {
      assertions = [
        {
          assertion = (cfg.colorscheme == "wallust") -> config.nos.cli-apps.wallust.enable;
          message = "nos.desktop.addons.rofi.colorScheme can't be \"wallust\" if nos.cli-apps.wallust.enable is false.";
        }
      ];

      nos = {
        home.configFile = {
          "rofi/config.rasi" = (mkIf cfg.enable) {
            text = readFile "${pkgs.nos.rofi-themes}/files/config.rasi";
          };
          "rofi/launcher.rasi" = mkIf cfg.launcher.enable {
            text = createRofiTheme launcherTheme;
          };
          # "rofi/power-menu.rasi" = mkIf cfg.powerMenu.enable { text = createRofiTheme power-menu-path; };
          # "rofi/power-menu-confirm.rasi" = mkIf (cfg.powerMenu.enable && builtins.pathExists filePath) {
          #   text = createRofiTheme power-menu-confirm-path;
          # };
        };
        system.fonts.system.extraFonts = [ pkgs.nos.rofi-themes ];
      };
    }
  ];
}
