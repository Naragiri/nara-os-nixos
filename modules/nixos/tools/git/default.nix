{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (lib.nos) enabled;
  cfg = config.nos.tools.git;
in
{
  options.nos.tools.git = {
    enable = mkEnableOption "Enable git.";
    userName = mkOption {
      default = "Naragiri";
      description = "The git username.";
      type = types.str;
    };
    userEmail = mkOption {
      default = "git@aluber.dev";
      description = "The git email.";
      type = types.str;
    };
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
    environment.systemPackages = with pkgs; [
      git
      lazygit
    ];

    nos.home.extraOptions.programs.git = enabled // {
      inherit (cfg) userName userEmail;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        safe.directory = "*";
      };
    };
  };
}
