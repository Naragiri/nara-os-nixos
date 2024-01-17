{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.apps.games.minecraft;
in
{
  options.nos.apps.games.minecraft = {
    enable = mkEnableOption "Enable Minecraft to be installed on the system.";
    enableBadlionClient = mkOption {
      default = true;
      description = ''
        Enable the Badlion Client for Minecraft.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ (prismlauncher.override { jdks = [ jdk8 jdk17 ]; }) ]
      ++ optionals (cfg.enableBadlionClient) [ nos.badlion-client ]; 
  };
}