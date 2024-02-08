{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.system.fonts;
in
{
  options.nos.system.fonts = with types; {
    terminus.enable = mkBoolOpt true "Enable the terminus fonts module.";
    system = {
      enable = mkBoolOpt true "Enable the system fonts module.";
      customFonts = mkOpt (listOf package) [] "Additional fonts to be used system wide.";
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