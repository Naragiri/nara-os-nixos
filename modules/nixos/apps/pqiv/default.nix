{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf generators;
  cfg = config.nos.apps.pqiv;

  settings = {
    options = {
      box-colors = "#FFFFFF:#000000";
      disable-backends = "archive,archive_cbx,libav,poppler,spectre,wand";
      hide-info-box = 1;
      max-depth = 1;
      window-position = "off";
    };
  };

  extraConfig = ''
    [actions]
    # hide cursor after 1 second inactivity
    set_cursor_auto_hide(1)
    # maintain window size
    toggle_scale_mode(5)

    [keybindings]
    t { montage_mode_enter() }
    x { command(rm $1) }
    z { toggle_scale_mode(0) }
    ? { command(>pqiv --show-bindings) }
    <BackSpace> { nop() }
    <Left> { goto_file_relative(-1) }
    <Right> { goto_file_relative(1) }
    <Up> { nop() }
    <Down> { nop() }

    @MONTAGE {
      t { montage_mode_return_cancel() }
    }
  '';
in
{
  options.nos.apps.pqiv = {
    enable = mkEnableOption "Enable pqiv.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.pqiv ];

    nos.home.configFile."pqivrc" = {
      text = lib.concatLines [
        (generators.toINI { } settings)
        extraConfig
      ];
    };

    nos.home.extraOptions.xdg.mimeApps.defaultApplications = {
      "image/jpeg" = "pqiv.desktop";
      "image/gif" = "pqiv.desktop";
      "image/webp" = "pqiv.desktop";
      "image/png" = "pqiv.desktop";
    };
  };
}
