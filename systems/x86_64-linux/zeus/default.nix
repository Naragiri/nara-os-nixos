{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) getExe;
  inherit (lib.nos) enabled;
  inherit (inputs) nixos-hardware;
in
{
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.framework-16-7040-amd
    nixos-hardware.nixosModules.common-gpu-amd
  ];

  nos = {
    apps = {
      chatterino = enabled;
      chromium = enabled // {
        makeDefaultBrowser = true;
      };
      discord = enabled;
      easyeffects = enabled // {
        preset = "ee_bryan_preset"; # https://community.frame.work/t/framework-16-sound-quality/46635
      };
      firefox = enabled;
      launchers = {
        lutris = enabled;
        xivlauncher = enabled;
      };
      minecraft = enabled;
      nemo = enabled;
      pqiv = enabled;
      qbittorrent = enabled;
      spotify = enabled;
      steam = enabled // {
        protonup = enabled;
      };
      terminal.kitty = enabled;
      vscode = enabled;
      # waydroid = enabled // { weston-wrapper = enabled; };
      # zen-browser = enabled;
    };
    cli-apps = {
      ani-cli = enabled;
      fastfetch = enabled;
      lf = enabled;
      ncmpcpp = enabled;
      # neovim = enabled;
      yazi = enabled;
    };
    desktop = {
      addons = {
        gammastep = enabled;
        gnome-keyring = enabled;
        gtk = enabled // {
          cursorTheme = {
            name = "Simp1e-Adw-Dark";
            package = pkgs.simp1e-cursors;
            size = 24;
          };
          iconTheme = {
            name = "Tela-manjaro";
            package = pkgs.tela-icon-theme;
            # name = "Papirus-Dark";
            # package = pkgs.papirus-icon-theme.override { color = "white"; };
          };
          theme = {
            # name = "catppuccin-mocha-teal-compact";
            # package = pkgs.catppuccin-gtk.override {
            #   accents = [ "teal" ];
            #   variant = "mocha";
            #   size = "compact";
            # };
            name = "Skeuos-Cyan-Dark";
            package = pkgs.nos.skeuos-gtk-theme.override {
              variant = "Dark";
              colorVariant = "Cyan";
            };
          };
        };
        polkit-gnome = enabled;
        rofi = enabled // {
          addons = {
            beats = enabled;
            calc = enabled;
            emoji = enabled;
          };
          rofi-themes = enabled // {
            launcher = enabled // {
              type = 2;
              style = 2;
            };
            colorscheme = "catppuccin-mocha";
          };
          wayland = enabled;
        };
        greetd = enabled;
        swaync = enabled;
        wallpapers = enabled // {
          # prism = enabled;
        };
        waybar = enabled;
        waypaper = enabled // {
          extraSettings.swww_transition_fps = 144;
        };
      };
      hyprland = enabled // {
        monitors = [
          {
            name = "eDP-1";
            width = 2560;
            height = 1600;
            refreshRate = 165;
            position = "2560x0";
            scale = "1.25";
            workspaces = [
              1
              2
              3
              4
              5
              6
              7
              8
              9
            ];
          }
        ];
        extraSettings = {
          input.touchpad = {
            disable_while_typing = true;
            natural_scroll = false;
            tap-to-click = true;
          };
          gestures = {
            workspace_swipe = true;
          };
          windowrulev2 = [
            "workspace 2 silent,tag:browser"
            "workspace 3 silent,tag:discord"
            "workspace 4 silent,tag:music"
            "workspace 5 silent,class:(steam)"
            "workspace 6, tag:games"
          ];
          workspace = [
            "special:scratchpad, on-created-empty:kitty"
          ];
        };
      };
    };
    hardware = {
      audio = enabled;
      bluetooth = enabled;
      network = enabled;
      ssd = enabled;
    };
    services = {
      flatpak = enabled;
      mpd = enabled;
      openssh = enabled;
      syncthing = enabled;
    };
    system = {
      battery = enabled;
      boot = {
        plymouth = enabled;
        lanzaboote = enabled;
      };
      security = {
        doas = enabled;
      };
    };
    tools = {
      common = enabled;
      direnv = enabled;
      disko = enabled;
      nix-ld = enabled;
      git = enabled;
      qmk = enabled;
      zoxide = enabled;
    };
  };

  services.xserver.displayManager.setupCommands = with pkgs; ''
    ${getExe xorg.xrandr} --output eDP-1 --scale 0.8x0.8
  '';

  services.fwupd.enable = true;

  system.stateVersion = "23.11";
}
