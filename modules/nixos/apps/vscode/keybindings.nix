_:
let
  tabSwitchKeybindings = builtins.concatLists (
    builtins.genList (kb: [
      {
        key = "ctrl+${toString kb}";
        command = "workbench.action.openEditorAtIndex${toString kb}";
      }
    ]) 9
  );
in
tabSwitchKeybindings
++ [
  {
    key = "ctrl+p";
    command = "workbench.action.quickOpen";
  }
  {
    key = "ctrl+shift+l";
    command = "workbench.action.toggleSidebarVisibility";
  }
]
