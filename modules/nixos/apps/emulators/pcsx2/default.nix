{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.emulators.pcsx2;

  pcsx2-xcb-wrapped = pkgs.writeShellScriptBin "pcsx2-xcb-wrapped" ''
    export QT_QPA_PLATFORM=xcb
    ${pkgs.pcsx2}/bin/pcsx2-qt "$1" -fullscreen -nogui
  '';
in
{
  options.nos.apps.emulators.pcsx2 = {
    enable = mkEnableOption "Enable pcsx2.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.pcsx2
      pcsx2-xcb-wrapped
    ];
  };
}
