{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    getExe
    ;
  inherit (pkgs.nos) nos-wallpapers;

  cfg = config.nos.desktop.addons.wallpapers;
in
{

  options.nos.desktop.addons.wallpapers = {
    enable = mkEnableOption "Enable wallpapers.";
    # TODO: make colorscheme global.
    colorscheme = mkOption {
      default = "catppuccin-mocha";
      description = "The colorscheme to apply to wallpapers.";
      type = types.oneOf [
        types.str
        types.attrs
      ];
    };
    prism.enable = mkEnableOption "Enable prism wallpaper recoloring.";
    wallpapersDir = mkOption {
      default = "/home/${config.nos.user.name}/Pictures/Wallpapers";
      description = "The directory to store wallpapers.";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    # adapted from https://github.com/IogaMaster/prism/blob/main/modules/home/prism/default.nix
    nos.home.file.wallpapers = {
      source =
        let
          scheme =
            if builtins.isAttrs cfg.colorscheme then
              lib.attrsets.attrValues cfg.colorscheme
            else
              lib.attrsets.attrValues inputs.nix-colors.colorschemes.${cfg.colorscheme}.palette;
          colors = "-- '${builtins.concatStringsSep "' '" scheme}'";
        in
        if cfg.prism.enable then
          pkgs.runCommand "prism" { } ''
            mkdir $out
            for WALLPAPER in $(find ${nos-wallpapers} -type f) 
            do
              ${getExe pkgs.lutgen} apply $WALLPAPER -o $out/$(basename $WALLPAPER) ${colors}
            done
          ''
        else
          "${nos-wallpapers}";

      target = cfg.wallpapersDir;
      recursive = true;
    };
  };
}
