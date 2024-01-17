{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.apps.tools.nix-ld;
in
{
  options.nos.apps.tools.nix-ld.enable = mkEnableOption "Enable the nix-ld module.";

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;
  };
}