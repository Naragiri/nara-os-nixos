{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.apps.tools.git;
in
{
  options.nos.apps.tools.git.enable = mkEnableOption "Enable the git module.";

  config = mkIf cfg.enable {
    # Git must be installed system-wide despite being installed by home-manager
    # or you will be unable to rebuild due to it not finding git.
    # just nixos being a bit quirky.
    environment.systemPackages = with pkgs; [ git ];

    environment.shellAliases = {
      "ga" = "git add";
      "gaa" = "git add .";
      "gaaa" = "git add -A";
      "gc" = "git commit";
      "gcm" = "git commit -m";
      "gd" = "git diff";
      "gi" = "git init";
      "gl" = "git log";
      "gpl" = "git pull";
      "gpsh" = "git push";
      "gs" = "git status";
      "gss" = "git status -s";
    };

    home.extraOptions.programs.git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };
}