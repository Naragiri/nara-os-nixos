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
    ;
  inherit (lib.nos) enabled;
  cfg = config.nos.services.mpd;
in
{
  options.nos.services.mpd = {
    enable = mkEnableOption "Enable mpd.";
    musicDirectory = mkOption {
      default = "/home/${config.nos.user.name}/Music";
      description = "The directory to source music from.";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mpc-cli ];

    systemd.services.mpd.environment = {
      XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.${config.nos.user.name}.uid}";
    };

    services.mpd = enabled // {
      user = "${config.nos.user.name}";
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
