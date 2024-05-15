{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.desktop.awesome;
in {
  options.nos.desktop.awesome = with types; {
    enable = mkEnableOption "Enable awesomewm with addons.";
  };

  config = mkIf cfg.enable {
    services.xserver = enabled // {
      windowManager.awesome = enabled // {
        package = pkgs.nos.awesome;
        luaModules = with pkgs.luaPackages; [ luarocks ];
      };
    };

    nos.apps = {
      terminal.kitty = enabled // { theme = "Nord"; };
      vscode = {
        extraExtensions = with pkgs; [
          nos.vscode-local-lua-debugger
          vscode-extensions.sumneko.lua
        ];
      };
    };

    nos.desktop = {
      addons = {
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
          colorScheme = "nord";
          appLauncher = enabled // {
            launcherType = 2;
            launcherStyle = 2;
          };
          powerMenu = enabled // {
            launcherType = 2;
            launcherStyle = 9;
          };
        };
        sddm = enabled // {
          theme = enabled // {
            name = "sugar-candy";
            package = pkgs.nos.sddm-sugar-candy.override {
              themeConfig = {
                General = {
                  AccentColor = "#efefef";
                  Background =
                    "${pkgs.nos.nos-wallpapers}/wallhaven-d6qj13.png";
                  FormPosition = "center";
                  FullBlur = "true";
                  PartialBlur = "false";
                };
              };
            };
          };
        };
        snixembed = enabled;
      };
    };

    nos.home.configFile = let getDir = file: "awesome/bin/nix/${file}";
    in {
      "${getDir "appLauncher.sh"}".source = pkgs.writeScript "app-launcher" ''
        ${
          getExe pkgs.rofi
        } -show drun -theme /home/${config.nos.user.name}/.config/rofi/app-launcher.rasi
      '';
    };

    xdg.portal = enabled // {
      config.common.default = "*";
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
