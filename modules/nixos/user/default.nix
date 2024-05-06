{ lib, config, options, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.user;
in {
  options.nos.user = with types; {
    name = mkStrOpt "nara" "The name for the main user account.";
    initialPassword =
      mkStrOpt "123" "The initial password for the main user account.";
    extraGroups =
      mkOpt (listOf str) [ ] "Extra groups for the main user account.";
    extraOptions =
      mkOpt attrs { } "Extra options passed to users.users.<name>.";
  };

  config = {
    nos.home = {
      file.".face".source = ./profile.png;
      file.".face.icon".source = ./profile.png;
      extraOptions.xdg = {
        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };
    };

    users.users.${cfg.name} = {
      inherit (cfg) name initialPassword;
      extraGroups =
        [ "wheel" "audio" "sound" "video" "networkmanager" "input" "tty" ]
        ++ cfg.extraGroups;
      group = "users";
      home = "/home/${cfg.name}";
      homeMode = "755";
      isNormalUser = true;
      packages = with pkgs; [ vim nano ];
      uid = 1000;
    } // cfg.extraOptions;
  };
}
