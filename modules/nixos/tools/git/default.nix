{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.tools.git;
in {
  options.nos.tools.git = with types; {
    enable = mkEnableOption "Enable git.";
    userName = mkStrOpt "Naragiri" "The username for git.";
    userEmail = mkStrOpt "git@aluber.dev" "The email for git.";
  };

  config = mkIf cfg.enable {
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

    # Git must be installed system-wide despite being added by home-manager
    # or you will be unable to rebuild due to it not finding git.
    # just nixos being a bit quirky.
    environment.systemPackages = with pkgs; [ git lazygit ];

    nos.home.extraOptions.programs.git = {
      enable = true;
      inherit (cfg) userName userEmail;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        safe.directory = "*";
      };
    };
  };
}
