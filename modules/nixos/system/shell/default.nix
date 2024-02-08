{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.system.shell;
in
{
  options.nos.system.shell = with types; {
    shell = mkOpt (enum [ "zsh" ]) "zsh" "The default shell for the system users.";
  };

  config = {
    environment.systemPackages = with pkgs; [
      eza
      bat
    ];

    users.defaultUserShell = pkgs.${cfg.shell};

    environment.shellAliases = {
      ".." = "cd ..";
      "rm" = "rm -rifv";
      "mv" = "mv -iv";
      "mkdir" = "mkdir -vp";
      "mkd" = "mkdir -pv";
      "cp" = "cp -riv";
      "cat" = "bat --paging=never --style=plain";
      "ls" = "exa -a --git --icons";
      "la" = "exa -la --git --icons";
      "tree" = "exa --tree --icons";
    };

    programs.zsh.enable = (cfg.shell == "zsh");

    home.extraOptions.programs.zsh = mkIf (cfg.shell == "zsh") {
      enable = true;
      dotDir = ".config/zsh";
      history.expireDuplicatesFirst = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
    };
  };
}