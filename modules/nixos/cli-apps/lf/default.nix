{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (lib.nos) enabled;
  cfg = config.nos.cli-apps.lf;

  previewer = pkgs.writeShellScriptBin "previewer" ''
    file=$1
    w=$2
    h=$3
    x=$4
    y=$5

    if [[ "$( ${getExe pkgs.file} -Lb --mime-type "$file")" =~ ^image ]]; then
        ${getExe pkgs.kitty} +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
        exit 1
    fi

    ${getExe pkgs.pistol} "$file"
  '';

  cleaner = pkgs.writeShellScriptBin "cleaner" "${getExe pkgs.kitty} +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty";
in
{
  options.nos.cli-apps.lf = {
    enable = mkEnableOption "Enable lf.";
  };

  config = mkIf cfg.enable {
    nos.home.configFile."lf/icons".source = ./lf-icons;

    nos.home.extraOptions.programs.lf = enabled // {
      commands = {
        mkdir = ''
          ''${{
            printf "Directory Name: "
            read DIR
            mkdir $DIR
          }}
        '';
      };
      keybindings = {
        n = "mkdir";
      };
      settings = {
        preview = true;
        hidden = true;
        drawbox = true;
        icons = true;
        ignorecase = true;
      };
      extraConfig = ''
        set cleaner ${getExe cleaner}
        set previewer ${getExe previewer}
      '';
    };
  };
}
