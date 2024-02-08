{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.system.service.flatpak;
in
{
  options.nos.system.service.flatpak.enable = mkEnableOption "Enable flatpak service to download non-nixos software.";

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}