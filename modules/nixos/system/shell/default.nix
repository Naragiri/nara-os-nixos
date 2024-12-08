{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkMerge
    types
    getExe
    ;
  inherit (lib.nos) enabled;
  cfg = config.nos.system.shell;
in
{
  options.nos.system.shell = {
    name = mkOption {
      default = "zsh";
      description = "The default system shell.";
      type = types.enum [ "zsh" ];
    };
  };

  config = mkMerge [
    {
      users.defaultUserShell = pkgs.${cfg.name};
      users.users.root.shell = pkgs.${cfg.name};

      environment.shellAliases = {
        ".." = "cd ..";
        "rm" = "rm -rifv";
        "mv" = "mv -iv";
        "mkdir" = "mkdir -vp";
        "cp" = "cp -riv";
        "cat" = "${getExe pkgs.bat} --paging=never --style=plain";
        "ls" = "${getExe pkgs.eza} -a --git --icons";
        "la" = "${getExe pkgs.eza} -la --git --icons";
        "tree" = "${getExe pkgs.eza} --tree --icons";
      };
    }
    (mkIf (cfg.name == "zsh") {
      programs.zsh = enabled;

      environment.pathsToLink = [ "/share/zsh" ];

      nos.home.extraOptions.programs.zsh = enabled // {
        autosuggestion = enabled;
        dotDir = ".zsh";
        enableCompletion = true;
        history.expireDuplicatesFirst = true;
        syntaxHighlighting = enabled;
      };
    })
  ];
}
