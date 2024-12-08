{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.tools.common;
in
{
  options.nos.tools.common.enable = mkEnableOption "Enable common tools.";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btop
      dig
      gparted
      gptfdisk
      killall
      man
      rar
      rsync
      tldr
      wget
      file
      unzip
      p7zip
      zip
    ];
  };
}
