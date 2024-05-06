{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.apps.launchers.xivlauncher;
in {
  options.nos.apps.launchers.xivlauncher = with types; {
    enable = mkEnableOption "Enable xivlauncher.";
  };

  config = mkIf cfg.enable {
    # TODO: Change to flatpak.
    # environment.systemPackages = with pkgs; [
    #   xivlauncher
    # ];
  };
}
