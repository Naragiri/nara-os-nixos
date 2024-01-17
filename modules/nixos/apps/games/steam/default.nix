{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.apps.games.steam;
in
{
  options.nos.apps.games.steam = {
    enable = mkEnableOption "Enable steam to install games.";
    enableConsoleSession = mkEnableOption "Enable SteamOS console session.";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [ mangohud gamescope ] 
      ++ optionals (cfg.enableConsoleSession) [
      (makeDesktopItem {
        name = "Steam (Gamepad UI)";
        desktopName = "Steam (Gamepad UI)";
        genericName = "Application for managing and playing games on Steam.";
        categories = ["Network" "FileTransfer" "Game"];
        type = "Application";
        icon = "steam";
        exec = "steamos";
        terminal = false;
      })
      (writeShellScriptBin "steamos" ''
        gamescope -F fsr -h 1440 -H 2160 -b -f -e --adaptive-sync -r 60 --expose-wayland -- steam -gamepadui -steamdeck -steamos -fulldesktopres -tenfoot
      '')
    ];

    services.xserver.windowManager.session = mkIf (cfg.enableConsoleSession) [
      {
        name = "Console";
        start = ''
          steamos
        '';
      }
    ];
  };
}