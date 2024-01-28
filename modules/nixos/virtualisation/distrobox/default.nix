{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.virtualisation.distrobox;
in
{
  options.nos.virtualisation.distrobox.enable = mkEnableOption "Enable the distrobox module.";

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    environment.systemPackages = with pkgs; [
      distrobox
    ];
  };
}