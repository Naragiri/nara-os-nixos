{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.hardware.audio;
in
{
  options.nos.hardware.audio = {
    enable = mkEnableOption "Enable pipewire.";
  };

  config = mkIf cfg.enable {
    security.rtkit = enabled;
    services.pipewire = enabled // {
      alsa = enabled // {
        support32Bit = true;
      };
      jack = enabled;
      pulse = enabled;
      wireplumber = enabled;
    };
    environment.systemPackages = [ pkgs.pavucontrol ];
  };
}
