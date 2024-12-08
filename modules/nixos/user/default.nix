{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.nos.user;
in
{
  options.nos.user = {
    name = mkOption {
      default = "nara";
      description = "The name for the user.";
      type = types.str;
    };
    initialPassword = mkOption {
      default = "123";
      description = "The initial password for the user.";
      type = types.str;
    };
    extraGroups = mkOption {
      default = [ ];
      description = "Extra groups for the user.";
      type = types.listOf types.str;
    };
    extraOptions = mkOption {
      default = { };
      description = "Extra options passed to users.users.<name>.";
      type = types.attrs;
    };
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
      extraGroups = [
        "wheel"
        "audio"
        "sound"
        "video"
        "networkmanager"
        "input"
        "tty"
        "dialout"
      ] ++ cfg.extraGroups;
      group = "users";
      home = "/home/${cfg.name}";
      homeMode = "755";
      isNormalUser = true;
      packages = [
        pkgs.vim
        pkgs.nano
      ];
      uid = 1000;
    } // cfg.extraOptions;
  };
}
