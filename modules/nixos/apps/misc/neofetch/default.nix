{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.apps.misc.neofetch;
in
{
  options.nos.apps.misc.neofetch.enable = mkEnableOption "Enable doas instead of sudo.";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ neofetch ];

    environment.shellAliases = {
      "nf" = "neofetch";
    };

    home.configFile."neofetch/config.conf".text = import ./config.nix;
  };
}