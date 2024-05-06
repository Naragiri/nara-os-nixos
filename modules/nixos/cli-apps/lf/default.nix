{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let
  previewer = pkgs.writeShellScriptBin "previewer" ''
    file=$1
    w=$2
    h=$3
    x=$4
    y=$5

    if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
        ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
        exit 1
    fi

    ${pkgs.pistol}/bin/pistol "$file"
  '';
  cleaner = pkgs.writeShellScriptBin "cleaner" ''
    ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
  '';

  cfg = config.nos.cli-apps.lf;
in {
  options.nos.cli-apps.lf = with types; {
    enable = mkEnableOption "Enable lf.";
  };

  config = mkIf cfg.enable {
    nos.home.configFile."lf/icons".source = ./lf-icons;

    nos.home.extraOptions.programs.lf = {
      enable = true;
      commands = {
        mkdir = ''
          ''${{
            printf "Directory Name: "
            read DIR
            mkdir $DIR
          }}
        '';
      };
      keybindings = { n = "mkdir"; };
      settings = {
        preview = true;
        hidden = true;
        drawbox = true;
        icons = true;
        ignorecase = true;
      };
      extraConfig = ''
        set cleaner ${cleaner}/bin/cleaner
        set previewer ${previewer}/bin/previewer
      '';
    };
  };
}
