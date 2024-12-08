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
    optionalAttrs
    optionals
    getExe
    ;
  inherit (lib.nos) mkEnabledOption enabled;
  cfg = config.nos.apps.nemo;

  fake-terminal = pkgs.writeShellApplication {
    name = "gnome-terminal";
    text = ''${getExe pkgs.kitty} -e "$@"'';
  };

  nemo-patched = pkgs.nemo-with-extensions.overrideAttrs (_: {
    postFixup = ''
      wrapProgram $out/bin/nemo --prefix PATH : "${lib.makeBinPath [ fake-terminal ]}"
    '';
  });
in
{
  options.nos.apps.nemo = {
    enable = mkEnableOption "Enable nemo.";
    fileRoller.enable = mkEnabledOption "Enable FileRoller.";
  };

  config = mkIf cfg.enable {
    programs.file-roller.enable = cfg.fileRoller.enable;

    services.gvfs = enabled;
    services.tumbler = enabled;

    nos.home.extraOptions = {
      dconf.settings = {
        "org/gnome/desktop/applications/terminal" = {
          exec = getExe pkgs.kitty;
        };
        "org/cinnamon/desktop/applications/terminal" = {
          exec = getExe pkgs.kitty;
        };
      };
      gtk.gtk3.bookmarks =
        let
          mkHomeFilePath = path: "file:///home/${config.nos.user.name}/${path}";
        in
        [
          (mkHomeFilePath "Repos")
        ]
        ++ optionals (config.networking.hostName == "hades") [ (mkHomeFilePath "Games") ];
      xdg.mimeApps.defaultApplications =
        {
          "inode/directory" = "nemo.desktop";
        }
        // optionalAttrs cfg.fileRoller.enable {
          "application/zip" = "org.gnome.FileRoller.desktop";
          "application/vnd.rar" = "org.gnome.FileRoller.desktop";
          "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        };
    };

    environment.systemPackages = [
      nemo-patched
    ] ++ optionals cfg.fileRoller.enable [ pkgs.nemo-fileroller ];
  };
}
