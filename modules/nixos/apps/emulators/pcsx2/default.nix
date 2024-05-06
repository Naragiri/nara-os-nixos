{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let
  pcsx2-xcb-wrapped = pkgs.writeShellScriptBin "pcsx2-xcb-wrapped" ''
    export QT_QPA_PLATFORM=xcb
    ${pkgs.pcsx2}/bin/pcsx2-qt "$1" -fullscreen -nogui
  '';
  cfg = config.nos.apps.emulators.pcsx2;
in {
  options.nos.apps.emulators.pcsx2 = with types; {
    enable = mkEnableOption "Enable pcsx2.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pcsx2 pcsx2-xcb-wrapped ];
  };
}
