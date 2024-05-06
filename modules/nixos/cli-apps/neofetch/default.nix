{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.cli-apps.neofetch;
in {
  options.nos.cli-apps.neofetch = with types; {
    enable = mkEnableOption "Enable neofetch.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ neofetch ];

    environment.shellAliases = { "nf" = "neofetch"; };

    nos.home.configFile."neofetch/config.conf".text = import ./config.nix;
  };
}
