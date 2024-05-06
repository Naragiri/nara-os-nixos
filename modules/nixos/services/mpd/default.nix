{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.services.mpd;
in {
  options.nos.services.mpd = with types; {
    enable = mkEnableOption "Enable mpd.";
    musicDirectory = mkStrOpt "/home/${config.nos.system.user.name}/Music"
      "The directory to source music from.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mpc-cli ];

    systemd.services.mpd.environment = {
      XDG_RUNTIME_DIR =
        "/run/user/${config.users.users.${config.nos.user.name}.uid}";
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
