{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.system.hardware.audio;
in
{
  options.nos.system.hardware.audio.enable = mkEnableOption "Enable pipewire on the device.";

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
}