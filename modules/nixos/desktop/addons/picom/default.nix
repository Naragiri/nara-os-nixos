{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.desktop.addons.picom;
in {
  options.nos.desktop.addons.picom = with types; {
    enable = mkEnableOption "Enable picom.";
  };

  config = mkIf cfg.enable {
    nos.home.extraOptions.services.picom = {
      enable = true;
      backend = "glx";
      package = pkgs.nos.compfy;
      settings =
        let mkList = a: list: lists.concatMap (s: [ "${a} = '${s}'" ]) list;
        in {
          vsync = true;

          corner-radius = 12;

          animations = true;
          animation-stiffness = 120;
          animation-window-mass = 0.5;
          animation-dampening = 12;
          animation-clamping = false;
          animation-for-open-window = "zoom";
          animation-for-unmap-window = "zoom";

          fading = true;
          fade-in-step = 3.0e-2;
          fade-out-step = 3.0e-2;
          fade-delta = 7;

          shadow = true;
          shadow-radius = 18;
          shadow-opacity = 0.5;
          shadow-offset-x = -18;
          shadow-offset-y = -18;

          opacity-rule = [
            "90:class_g = 'Code'"
            "95:class_g = 'discord'"
            "90:class_g = 'Rofi'"
          ];

          shadow-exclude = [ ]
            ++ (mkList "window_type" [ "dock" "menu" "popup_menu" "utility" ]);

          rounded-corners-exclude = [ ] ++ (mkList "window_type" [ "dock" ]);

          animation-open-exclude = [ ]
            ++ (mkList "window_type" [ "popup_menu" "menu" "utility" ])
            ++ (mkList "class_g" [ "i3lock" "flameshot" "Dunst" ]);

          animation-unmap-exclude = [ ]
            ++ (mkList "window_type" [ "popup_menu" "menu" "utility" ])
            ++ (mkList "class_g" [ "i3lock" "flameshot" "Dunst" ]);
        };
    };
  };
}
