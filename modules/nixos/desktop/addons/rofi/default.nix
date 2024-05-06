{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let
  rofi-app-launcher = pkgs.writeShellScriptBin "rofi-app-launcher" ''
    dir=/home/${config.nos.user.name}/.config/rofi
    theme=app-launcher
    ${getExe pkgs.rofi} -show drun -theme $dir/$theme.rasi
  '';

  rofi-power-menu = let
    power-menu-file = "${rofi-theme-files}/powermenu/type-${
        toString cfg.powerMenu.launcherType
      }/powermenu.sh";

    power-menu = replaceStrings [
      "dir="
      "theme="
      "uptime -p"
      "rofi "
      "chosen="
      "shared/confirm"
    ] [
      "# dir="
      "# theme="
      "$uptime -p"
      "$rofi "
      "return="
      "power-menu-confirm"
    ] "${readFile power-menu-file}";
  in pkgs.writeShellScriptBin "rofi-power-menu" ''
    dir=/home/${config.nos.user.name}/.config/rofi
    confirm=power-menu-confirm
    theme=power-menu
    uptime=${pkgs.procps}/bin/uptime
    rofi=${getExe pkgs.rofi}

    ${power-menu}

    run_command() {
      selected="$(confirm_exit)"
      if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
          systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
          systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
          systemctl suspend
        elif [[ $1 == '--hibernate' ]]; then
          systemctl hibernate
        elif [[ $1 == '--logout' ]]; then
          if [[ "$DESKTOP_SESSION" == 'none+bspwm' ]]; then
            bspc quit
          elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
            i3-msg exit
          fi
        fi
      else
        exit 0
      fi
    }

    case ''${return} in
      $shutdown)
        run_command --shutdown
          ;;
      $reboot)
        run_command --reboot
          ;;
      $lock)
        ${
          optionalString (config.nos.desktop.screenLocker.enable) getExe
          config.nos.desktop.screenLocker.script
        }
          ;;
      $suspend)
        run_command --suspend
          ;;
      $hibernate)
        run_command --hibernate
          ;;
      $logout)
        run_command --logout
          ;;
    esac
  '';

  cfg = config.nos.desktop.addons.rofi;
  rofi-theme-files = "${pkgs.nos.rofi-themes}/files";

  color-schemes = [
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
    "yousai"
  ];

  createRofiTheme = let
    color-scheme = ''
      @import "${rofi-theme-files}/colors/${cfg.colorScheme}.rasi"
    '';
  in rasiPath: ''
    ${color-scheme}

    element alternate.normal {
      background-color:            @background;
      foreground-color:            @foreground;
    }

    ${replaceStrings [ "@import" ] [ "// @import" ] (readFile rasiPath)}
  '';

  app-launcher-path = "${rofi-theme-files}/launchers/type-${
      toString cfg.appLauncher.launcherType
    }/style-${toString cfg.appLauncher.launcherStyle}.rasi";

  power-menu-path = "${rofi-theme-files}/powermenu/type-${
      toString cfg.powerMenu.launcherType
    }/style-${toString cfg.powerMenu.launcherStyle}.rasi";

  power-menu-confirm-path = "${rofi-theme-files}/powermenu/type-${
      toString cfg.powerMenu.launcherType
    }/shared/confirm.rasi";
in {
  options.nos.desktop.addons.rofi = with types; {
    enable = mkEnableOption "Enable rofi.";
    colorScheme =
      mkOpt (enum color-schemes) "onedark" "The colorscheme for rofi.";
    appLauncher = {
      enable = mkEnableOption "Enable app launcher.";
      launcherType = mkNumOpt 1 "The type for the launcher.";
      launcherStyle = mkNumOpt 5 "The style for the launcher.";
      script =
        mkOpt package rofi-app-launcher "The script to run the app launcher.";
    };
    powerMenu = {
      enable = mkEnableOption "Enable power menu.";
      launcherType = mkNumOpt 2 "The type for the power menu.";
      launcherStyle = mkNumOpt 1 "The style for the power menu.";
      script =
        mkOpt package rofi-power-menu "The script to run the power menu.";
    };
  };

  config = mkIf cfg.enable {
    nos.home.configFile."rofi/config.rasi" =
      mkIf cfg.enable { text = readFile "${rofi-theme-files}/config.rasi"; };

    nos.home.configFile."rofi/app-launcher.rasi" =
      mkIf cfg.appLauncher.enable { text = createRofiTheme app-launcher-path; };

    nos.home.configFile."rofi/power-menu.rasi" =
      mkIf cfg.powerMenu.enable { text = createRofiTheme power-menu-path; };

    nos.home.configFile."rofi/power-menu-confirm.rasi" = mkIf
      (cfg.powerMenu.enable && builtins.pathExists power-menu-confirm-path) {
        text = createRofiTheme power-menu-confirm-path;
      };

    nos.system.fonts.system.extraFonts = with pkgs; [ nos.rofi-themes ];
  };
}
