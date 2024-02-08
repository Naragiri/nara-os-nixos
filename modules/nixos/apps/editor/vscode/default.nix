{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.apps.editor.vscode;
in
{
  options.nos.apps.editor.vscode.enable = mkEnableOption "Enable vscode with preset settings.";

  config = mkIf cfg.enable {
    environment.shellAliases = {
      "c" = "code .";
    };

    home.extraOptions.programs.vscode = {
      enable = true;
      extensions = with pkgs; [
        vscode-extensions.vscode-icons-team.vscode-icons
        nos.vscode-just-black
      ];
      userSettings = {
        "search.exclude" = {
          "**/node_modules" = true;
          "**/bower_components" = true;
          "**/*.code-search" = true;
        };
        "search.useIgnoreFiles" = true;
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.fontFamily" = "CaskaydiaCove Nerd Font";
        "editor.fontLigatures" = true;
        "editor.tabSize" = 2;
        "extensions.ignoreRecommendations" = true;
        "files.autoSave" = "off";
        "files.eol" = "\n";
        "terminal.integrated.fontFamily" = "CaskaydiaCove Nerd Font";
        "terminal.integrated.fontSize" = 16;
        "vsicons.dontShowNewVersionMessage" = true;
        "workbench.colorTheme" = "Just Black";
        "workbench.iconTheme" = "vscode-icons";
        "window.zoomLevel" = 3;
      };
    };
  };
}