{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let
  jsonFormat = pkgs.formats.json { };

  switchingKeybindings = builtins.concatLists (builtins.genList (kb: [{
    key = "ctrl+${toString kb}";
    command = "workbench.action.openEditorAtIndex${toString kb}";
  }]) 9);

  default-extensions = with pkgs; [
    nos.vscode-nix
    vscode-extensions.gruntfuggly.todo-tree
    vscode-extensions.vscode-icons-team.vscode-icons
  ];

  default-keybindings = switchingKeybindings ++ [
    {
      key = "ctrl+p";
      command = "workbench.action.quickOpen";
    }
    {
      key = "ctrl+shift+l";
      command = "workbench.action.toggleSidebarVisibility";
    }
  ];

  default-user-settings = {
    "editor.formatOnPaste" = true;
    "editor.formatOnSave" = true;
    "editor.fontFamily" = "${cfg.font.name}";
    "editor.fontLigatures" = cfg.font.ligatures.enable;
    "editor.minimap.enabled" = false;
    "editor.tabSize" = 2;
    "explorer.confirmDragAndDrop" = false;
    "explorer.openEditors.visible" = 1;
    "extensions.ignoreRecommendations" = true;
    "files.autoSave" = "off";
    "files.eol" = "\n";
    "search.exclude" = {
      "**/node_modules" = true;
      "**/bower_components" = true;
      "**/*.code-search" = true;
    };
    "search.useIgnoreFiles" = true;
    "terminal.integrated.fontFamily" = "${cfg.font.name}";
    "terminal.integrated.fontSize" = cfg.font.size;
    "telemetry.enableCrashReporter" = false;
    "telemetry.enableTelemetry" = false;
    "telemetry.telemetryLevel" = "off";
    "update.mode" = "none";
    "vsicons.dontShowNewVersionMessage" = true;
    "workbench.editor.limit.enabled" = true;
    "workbench.editor.limit.value" = 9;
    "workbench.iconTheme" = "vscode-icons";
    "workbench.sideBar.location" = "right";
    "workbench.startupEditor" = "newUntitledFile";
    "workbench.statusBar.visible" = false;
    "window.menuBarVisibility" = "hidden";
    "window.zoomLevel" = 3;
  };

  vsc-extensions = default-extensions ++ cfg.extraExtensions
    ++ optionals (cfg.theme.enable) [ cfg.theme.package ];
  vsc-keybindings = default-keybindings ++ cfg.extraKeybindings;
  vsc-user-settings = default-user-settings // cfg.extraUserSettings
    // optionalAttrs (cfg.theme.enable) {
      "workbench.colorTheme" = cfg.theme.name;
    };

  cfg = config.nos.apps.vscode;
in {
  options.nos.apps.vscode = with types; {
    enable = mkEnableOption "Enable vscode with custom config.";
    extraExtensions =
      mkOpt (listOf package) default-extensions "Extra extensions for vscode.";
    extraKeybindings =
      mkOpt (listOf attrs) default-keybindings "Extra keybindings for vscode.";
    extraUserSettings =
      mkOpt jsonFormat.type { } "Extra user settings for vscode.";
    font = {
      name = mkStrOpt "CaskaydiaCove Nerd Font" "The font to use for vscode.";
      ligatures.enable = mkEnabledOption "Enable font ligatures.";
      size = mkNumOpt 16 "The size of the font for vscode.";
    };
    theme = {
      enable = mkEnableOption "Enable vscode themeing.";
      name = mkStrOpt "" "The name of the vscode theme.";
      package = mkNullOpt package null "The package of the vscode theme.";
    };
  };

  config = mkIf cfg.enable {
    environment.shellAliases = { "c" = "codium ."; };

    nos.home.extraOptions.programs.vscode = {
      enable = true;
      extensions = vsc-extensions;
      keybindings = vsc-keybindings;
      mutableExtensionsDir = false;
      package = pkgs.vscodium;
      userSettings = vsc-user-settings;
    };
  };
}
