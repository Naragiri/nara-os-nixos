{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.apps.terminal.kitty;
in
{
  options.nos.apps.terminal.kitty.enable = mkEnableOption "Enable the kitty terminal module.";

  config = mkIf cfg.enable {
    home.extraOptions.programs.kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        size = 14;
      };
      settings = {
        window_padding_width = 8;
        confirm_os_window_close = -1;
      };
    };

    environment.systemPackages = with pkgs; [
      kitty
    ];
  };
}