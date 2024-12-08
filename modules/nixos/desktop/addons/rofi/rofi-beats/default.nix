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
    mkOption
    types
    getExe
    ;
  cfg = config.nos.desktop.addons.rofi.rofi-beats;

  rofi-beats-script = pkgs.writeShellScriptBin "rofi-beats-script" ''
    notification(){
    	${pkgs.libnotify}/bin/notify-send "Now Playing: " "$@" --icon=media-tape
    }

    menu(){
    	printf "1. Tokyo Lofi Chill Beats\n"
    	printf "2. Gensokyo Radio (Enhanced)"
    }

    main() {
      # TODO: Fix rofi
    	choice=$(menu | ${getExe config.nos.desktop.addons.rofi.finalPackage} -dmenu | cut -d. -f1)

    	case $choice in
        1)
          notification "Tokyo Lofi Chill Beats ☕️🎶";
          URL="https://youtu.be/aybEkSxCbtk"
          ARGS="--no-video"
          break ;;
        2)
          notification "Gensokyo Radio (Enhanced) ☕️🎶";
          URL="https://stream.gensokyoradio.net/3"
          ARGS=""
          break ;;
    	esac

      ${getExe pkgs.mpv} $ARGS --title="rofi-beats-mpv" $URL
    }

    pkill -f "rofi-beats-mpv" || main
  '';
in
# 1)
# 	notification "Lofi Girl ☕️🎶";
#         URL="https://play.streamafrica.net/lofiradio"
# 	break
# 	;;
# 2)
# 	notification "Chillhop ☕️🎶";
#         URL="http://stream.zeno.fm/fyn8eh3h5f8uv"
# 	break
# 	;;
# 3)
# 	notification "Box Lofi ☕️🎶";
#         URL="http://stream.zeno.fm/f3wvbbqmdg8uv"
# 	break
# 	;;
# 4)
# 	notification "The Bootleg Boy ☕️🎶";
#         URL="http://stream.zeno.fm/0r0xa792kwzuv"
# 	break
# 	;;
# 5)
# 	notification "Radio Spinner ☕️🎶";
#         URL="https://live.radiospinner.com/lofi-hip-hop-64"
# 	break
# 	;;
# 6)
# 	notification "SmoothChill ☕️🎶";
#         URL="https://media-ssl.musicradio.com/SmoothChill"
# 	break
# 	;;
{
  options.nos.desktop.addons.rofi.rofi-beats = {
    enable = mkEnableOption "Enable rofi-beats.";
    # TODO: Make args per station.
    mpvArgs = mkOption {
      default = "--no-video --volume=60";
      description = "Args to pass to mpv.";
      type = types.str;
    };
    script = mkOption {
      description = "The script to run rofi-beats.";
      readOnly = true;
      type = types.package;
    };
    stations = mkOption {
      default = { };
      description = "The stations to choose from.";
      type = types.attrs;
    };
  };

  config = mkIf cfg.enable {
    nos.desktop.addons.rofi.rofi-beats.script = rofi-beats-script;
  };
}
