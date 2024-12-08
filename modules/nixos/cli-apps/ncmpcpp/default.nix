{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.cli-apps.ncmpcpp;
in
{
  options.nos.cli-apps.ncmpcpp = {
    enable = mkEnableOption "Enable ncmpcpp.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.programs.ncmpcpp = enabled // {
      mpdMusicDir = "${config.nos.services.mpd.musicDirectory}";
    };
  };
}
