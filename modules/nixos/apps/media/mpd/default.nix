{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.apps.media.mpd;
in
{
  options.nos.apps.media.mpd = with types; {
    enable = mkEnableOption "Enable the mpd media daemon.";
    musicDirectory = mkStrOpt "/home/${config.nos.system.user.name}/Music" "The directory to source music from.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mpc-cli
    ];

    home.extraOptions.programs.ncmpcpp = {
      enable = true;
      mpdMusicDir = "${cfg.musicDirectory}";
    };

    # TODO: unhardcode this
    systemd.services.mpd.environment = {
      XDG_RUNTIME_DIR = "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
    };

    services.mpd = {
      enable = true;
      user = "${config.nos.system.user.name}";
      musicDirectory = "${cfg.musicDirectory}";
      extraConfig = ''
        auto_update "yes"

        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
  };
}