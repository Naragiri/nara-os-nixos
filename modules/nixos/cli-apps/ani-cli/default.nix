{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.cli-apps.ani-cli;
in {
  options.nos.cli-apps.ani-cli = with types; {
    enable = mkEnableOption "Enable ani-cli.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ ani-cli ]; };
}
