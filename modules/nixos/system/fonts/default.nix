{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    types
    ;
  inherit (lib.nos) mkEnabledOption enabled;
  cfg = config.nos.system.fonts;
in
{
  options.nos.system.fonts = {
    terminus.enable = mkEnabledOption "Enable terminus fonts.";
    system = {
      enable = mkEnabledOption "Enable system fonts.";
      extraFonts = mkOption {
        default = [ ];
        description = "Additional system fonts.";
        type = types.listOf types.package;
      };
    };
  };

  config = {
    fonts = mkIf cfg.system.enable {
      fontDir = enabled;
      packages =
        [
          pkgs.noto-fonts
          pkgs.noto-fonts-emoji
          pkgs.font-awesome
          pkgs.fira-code-symbols
          (pkgs.nerdfonts.override {
            fonts = [
              "FiraCode"
              "JetBrainsMono"
              "CascadiaCode"
            ];
          })
        ]
        # 25.05
        # ++ (with pkgs.nerd-fonts; [
        #   fira-code
        #   jetbrains-mono
        #   caskaydia-cove
        # ])
        ++ cfg.system.extraFonts;
    };

    console = mkIf cfg.terminus.enable {
      earlySetup = true;
      packages = [ pkgs.terminus_font ];
      font = "ter-v22b";
    };
  };
}
