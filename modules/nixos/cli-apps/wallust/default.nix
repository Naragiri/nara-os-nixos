{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let
  cfg = config.nos.cli-apps.wallust;
  tomlFormat = pkgs.formats.toml { };
in {
  options.nos.cli-apps.wallust = with types; {
    enable = mkEnableOption "Enable wallust.";
    pywalCompat.enable =
      mkEnableOption "Add a legacy template for pywal colors.";
    shell.enable = mkEnableOption "Add shell init hook.";
    templates = mkOption {
      type = attrsOf (submodule {
        options = {
          new_engine =
            mkBoolOpt true "Should this template use the new engine.";
          text = mkStrOpt "" "Content of the template file.";
          target = mkStrOpt ""
            "Absolute path to the file to write the template after processing.";
        };
      });
      default = { };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wallust ];

    nos.home.extraOptions.programs = let
      current-shell = config.nos.system.shell.name;
      wallust-colors-file =
        "/home/${config.nos.user.name}/.cache/wallust/sequences";
    in mkIf (cfg.shell.enable) {
      zsh.initExtra = mkIf (current-shell == "zsh") ''
        wallust_colors="${wallust-colors-file}"
        if [ -e "$wallust_colors" ]; then
          command cat "$wallust_colors"
        fi
      '';
    };

    nos.cli-apps.wallust.templates = {
      "pywal-compat" = mkIf (cfg.pywalCompat.enable) {
        text = ''
          {{color0}}
          {{color1}}
          {{color2}}
          {{color3}}
          {{color4}}
          {{color5}}
          {{color6}}
          {{color7}}
          {{color8}}
          {{color9}}
          {{color10}}
          {{color11}}
          {{color12}}
          {{color13}}
          {{color14}}
          {{color15}}
        '';
        target = "/home/${config.nos.user.name}/.cache/wal/colors";
      };
    };

    nos.home.configFile = {
      "wallust/wallust.toml".source = tomlFormat.generate "wallust-toml" {
        backend = "resized";
        check_contrast = true;
        color_space = "labmixed";
        fallback_generator = "interpolate";
        palette = "dark16";
        templates = lib.mapAttrs (filename: attr: {
          inherit (attr) target new_engine;
          template = filename;
        }) cfg.templates;
        threshold = 20;
      };
    } // (lib.mapAttrs' (template:
      { text, ... }:
      lib.nameValuePair "wallust/${template}" { inherit text; }) cfg.templates);
  };
}
