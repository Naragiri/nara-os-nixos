{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.apps.games.steam;
in
{
  options.nos.apps.games.steam = {
    enable = mkEnableOption "Enable steam to install games.";
    consoleSession.enable = mkEnableOption "Enable SteamOS console session.";
  };

  config = mkIf cfg.enable {
    hardware.xone.enable = true;

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [ mangohud gamescope ] 
      ++ optionals (cfg.consoleSession.enable) [
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
        gamescope -F fsr -h 1080 -H 1440 -b -f -e --adaptive-sync -r 144 --expose-wayland -- steam -gamepadui -steamdeck -steamos -fulldesktopres -tenfoot
      '')
      (writeShellScriptBin "steamos-tv" ''
        gamescope --prefer-output HDMI-A-1 -F fsr -h 1440 -H 2160 -b -f -e --adaptive-sync -r 60 --expose-wayland -- steam -gamepadui -steamdeck -steamos -fulldesktopres -tenfoot
      '')
    ];

    services.xserver.windowManager.session = mkIf (cfg.consoleSession.enable) [
      {
        name = "Console";
        start = ''
          steamos
        '';
      }
    ];
  };
}
