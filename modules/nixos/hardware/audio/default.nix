{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.hardware.audio;
in {
  options.nos.hardware.audio = with types; {
    enable = mkEnableOption "Enable pipewire.";
  };

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
    environment.systemPackages = with pkgs; [ pavucontrol ];
  };
}
