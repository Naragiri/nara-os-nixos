{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.nos.system.fonts;
in
{
  options.nos.system.fonts = with types; {
    terminus.enable = mkOption {
      type = bool;
      default = true;
      description = "Enable the terminus fonts module.";
    };
    system = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Enable the system fonts module.";
      };
      customFonts = mkOption {
        type = (listOf package);
        default = [];
        description = "Additional fonts to be used system wide.";
      };
    };
  };

  config = let
    systemFonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      font-awesome
      fira-code-symbols
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "CascadiaCode" ]; })
    ];
  in {
    fonts = {
      fontDir.enable = true;
      packages = optionals (cfg.system.enable) (systemFonts ++ cfg.system.customFonts);
    };

    console = mkIf (cfg.terminus.enable) {
      earlySetup = true;
      packages = with pkgs; [ terminus_font ];
      font = "ter-v22b";
    };
  };
}