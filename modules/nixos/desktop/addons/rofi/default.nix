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
    mkMerge
    types
    getExe
    ;
  inherit (lib.nos) enabled;
  cfg = config.nos.desktop.addons.rofi;

  rofi-launcher-wrapped = pkgs.writeShellScriptBin "rofi-launcher-wrapped" (
    if cfg.rofi-themes.enable && cfg.rofi-themes.launcher.enable then
      "${getExe cfg.finalPackage} -theme /home/${config.nos.user.name}/.config/rofi/launcher.rasi $@"
    else
      "${getExe cfg.finalPackage} $@"
  );
in
{
  options.nos.desktop.addons.rofi = {
    enable = mkEnableOption "Enable rofi.";
    addons = {
      beats.enable = mkEnableOption "Enable the rofi beats addon.";
      calc.enable = mkEnableOption "Enable the rofi calc addon.";
      emoji.enable = mkEnableOption "Enable the rofi emoji addon.";
    };
    extraConfig = mkOption {
      default = { };
      description = "Extra rofi config options.";
      type = types.attrs;
    };
    finalPackage = mkOption {
      description = "The rofi package.";
      readOnly = true;
      type = types.package;
    };
    script = mkOption {
      default = rofi-launcher-wrapped;
      description = "The script to launch rofi.";
      readOnly = true;
      type = types.package;
    };
    wayland.enable = mkEnableOption "Use wayland instead of x11.";
  };

  config = mkIf cfg.enable {
    nos = {
      desktop = {
        addons.rofi = {
          finalPackage = if cfg.wayland.enable then pkgs.rofi-wayland else pkgs.rofi;
          rofi-beats.enable = cfg.addons.beats.enable;
        };
        hyprland.extraSettings = {
          bind =
            let
              mkRofiCommand = command: "pkill rofi || ${getExe config.nos.desktop.addons.rofi.script} ${command}";
            in
            # TODO: Fix rofi
            [
              "$mod, Space, exec, ${mkRofiCommand "-show drun"}"
              # "$mod, period, exec, ${mkRofiCommand' "-show emoji"}" # TODO: Fix
              "$mod SHIFT, B, exec, ${getExe cfg.rofi-beats.script}" # TODO: Fix, mergeattrs doesn't like bind being declared twice.
            ];
        };
      };
      home.extraOptions.programs.rofi = enabled // {
        package = cfg.finalPackage;
        plugins =
          let
            rofi-unwrapped = if cfg.wayland.enable then pkgs.rofi-wayland-unwrapped else pkgs.rofi-unwrapped;
          in
          mkMerge [
            (mkIf cfg.addons.calc.enable [
              (pkgs.rofi-calc.override { inherit rofi-unwrapped; })
            ])
            (mkIf cfg.addons.emoji.enable [
              (if cfg.wayland.enable then pkgs.rofi-emoji-wayland else pkgs.rofi-emoji)
            ])
          ];
      };
    };
  };
}
