{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe
    ;
  inherit (lib.nos) mkEnabledOption;
  cfg = config.nos.apps.waydroid;

  westonWrapper =
    let
      waydroid-wrapped = pkgs.writeShellApplication {
        name = "waydroid-wrapped";
        runtimeInputs = with pkgs; [ waydroid ];
        text = ''
          waydroid session stop
          waydroid show-full-ui
        '';
      };

      westonINI = (pkgs.formats.ini { }).generate "weston-waydroid.ini" {
        shell.panel-position = "none";
        autolaunch = {
          path = "${getExe waydroid-wrapped}";
          watch = true;
        };
      };

    in
    pkgs.writeShellScriptBin "weston-waydroid-wrapper" ''
      ${getExe pkgs.weston} -c ${westonINI} --width 1920 --height 1080
    '';
in
{
  options.nos.apps.waydroid = {
    enable = mkEnableOption "Enable waydroid.";
    openFirewall = mkEnabledOption "Option firewall ports.";
    westonWrapper.enable = mkEnableOption "Enable weston wrapper for use in x11.";
  };

  config = mkIf cfg.enable {
    virtualisation.waydroid.enable = true;

    # networking.firewall = mkIf cfg.openFirewall {
    #   allowedTCPPorts = [ 67 53 ];
    #   allowedUDPPorts = [ 67 53 ];
    # };

    environment.systemPackages = mkIf cfg.westonWrapper.enable [
      westonWrapper
      (pkgs.makeDesktopItem {
        name = "Waydroid (Weston)";
        desktopName = "Waydroid (Weston)";
        categories = [ "X-WayDroid-App" ];
        type = "Application";
        icon = "waydroid";
        exec = "${getExe westonWrapper}";
        terminal = false;
      })
    ];
  };
}
