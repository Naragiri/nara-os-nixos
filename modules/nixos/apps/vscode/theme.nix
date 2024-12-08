{ lib, pkgs, ... }:
let
  inherit (lib.nos.vscode) configuredExtension;

  # Sweet Dracula Monokai
  # themeExtension = pkgs.vscode-extensions.lefd.sweet-dracula-monokai;
  # themeName = "Sweet Dracula Monokai";

  # Lukin
  themeExtension = pkgs.vscode-extensions.lukinco.lukin-vscode-theme;
  themeName = "Lukin Theme";
in
configuredExtension {
  extension = themeExtension;
  settings = {
    workbench.colorTheme = themeName;
  };
}
