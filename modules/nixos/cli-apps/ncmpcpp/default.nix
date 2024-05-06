{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.cli-apps.ncmpcpp;
in {
  options.nos.cli-apps.ncmpcpp = with types; {
    enable = mkEnableOption "Enable ncmpcpp.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.programs.ncmpcpp = {
      enable = true;
      mpdMusicDir = "${config.nos.services.mpd.musicDirectory}";
    };
  };
}
