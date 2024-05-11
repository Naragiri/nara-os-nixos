{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let
  cfg = config.nos.apps.nemo;
  fake-terminal = pkgs.writeShellApplication {
    name = "gnome-terminal";
    text = ''${getExe pkgs.kitty} -e "$@"'';
  };
  nemo-patched = pkgs.cinnamon.nemo-with-extensions.overrideAttrs (_: {
    postFixup = ''
      wrapProgram $out/bin/nemo --prefix PATH : "${
        lib.makeBinPath [ fake-terminal ]
      }"
    '';
  });
in {
  options.nos.apps.nemo = with types; {
    enable = mkEnableOption "Enable nemo.";
    fileRoller.enable = mkEnabledOption "Enable FileRoller.";
  };

  config = mkIf cfg.enable {
    programs.file-roller.enable = cfg.fileRoller.enable;

    nos.home.extraOptions = {
      dconf.settings = {
        "org/gnome/desktop/applications/terminal" = {
          exec = getExe pkgs.kitty;
        };
        "org/cinnamon/desktop/applications/terminal" = {
          exec = getExe pkgs.kitty;
        };
      };
      xdg.mimeApps.defaultApplications = {
        "inode/directory" = "nemo.desktop";
      } // optionalAttrs cfg.fileRoller.enable {
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/vnd.rar" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
      };
    };

    environment.systemPackages = with pkgs;
      [ nemo-patched ]
      ++ optionals (cfg.fileRoller.enable) [ cinnamon.nemo-fileroller ];
  };
}
