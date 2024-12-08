{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (lib.nos) enabled;
  cfg = config.nos.desktop.awesome;
in
{
  options.nos.desktop.awesome = {
    enable = mkEnableOption "Enable awesomewm with addons.";
  };

  config = mkIf cfg.enable {
    services = {
      displayManager.defaultSession = "none+awesome";
      xserver = enabled // {
        windowManager.awesome = enabled // {
          package = pkgs.nos.awesome-git.override {
            extraGIPackages = with pkgs; [ upower ];
          };
          luaModules = with pkgs.luaPackages; [ luarocks ];
        };
      };
    };

    nos = {
      apps = {
        terminal.kitty = enabled;
        # vscode = {
        #   extraExtensions = with pkgs; [
        #     nos.vscode-local-lua-debugger
        #     vscode-extensions.sumneko.lua
        #   ];
        # };
      };
      desktop.addons = {
        gnome-keyring = enabled;
        gtk = enabled // {
          cursorTheme = {
            name = "Simp1e-Adw-Dark";
            package = pkgs.simp1e-cursors;
            size = 24;
          };
          iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme.override { color = "cyan"; };
          };
          theme = {
            name = "Skeuos-Cyan-Dark";
            package = pkgs.nos.skeuos-gtk-theme.override {
              variant = "Dark";
              colorVariant = "Cyan";
            };
          };
        };
        picom = enabled;
        polkit-gnome = enabled;
        redshift = enabled;
        rofi = enabled // {
          # colorScheme = "nord";
          # appLauncher = enabled // {
          #   launcherType = 2;
          #   launcherStyle = 2;
          # };
          # powerMenu = enabled // {
          #   launcherType = 2;
          #   launcherStyle = 9;
          # };
        };
        sddm = enabled // {
          theme = enabled // {
            name = "sugar-candy";
            package = pkgs.nos.sddm-sugar-candy.override {
              themeConfig = {
                General = {
                  AccentColor = "#efefef";
                  Background = "${pkgs.nos.nos-wallpapers}/wallhaven-r2g7rm.jpg";
                  FormPosition = "center";
                  FullBlur = "true";
                  PartialBlur = "false";
                };
              };
            };
          };
        };
        snixembed = enabled;
        wallpapers = enabled;
      };
      home.configFile =
        let
          getDir = file: "awesome/bin/${file}";
        in
        {
          "${getDir "app_launcher.sh"}".source = getExe config.nos.desktop.addons.rofi.script;
        };
    };

    xdg.portal = enabled // {
      xdgOpenUsePortal = true;
      config = {
        common.default = [ "gtk" ];
      };
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
