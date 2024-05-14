{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.services.syncthing;
in {
  options.nos.services.syncthing = with types; {
    enable = mkEnableOption "Enable syncthing.";
  };

  config = mkIf cfg.enable {
    services.syncthing = let
      username = config.nos.user.name;
      group = config.users.users.${username}.group;
    in {
      enable = true;
      dataDir = "/home/${username}/.syncthing";
      configDir = "/home/${username}/.config/syncthing";
      user = "${username}";
      group = "${group}";
      settings = {
        devices = {
          "hades" = {
            id =
              "NPFCSL2-FDX65IN-6757H2F-6BBOONP-RX77E5C-3UQGUBF-MSUB43U-VUCWCQF";
          };
          # "zeus" = { id = "1"; };
        };
        folders = {
          "Repos" = {
            path = "/home/${username}/Repos";
            devices = [ "hades" ];
            versioning = {
              type = "staggered";
              params = {
                cleanInterval = "3600"; # 1 hour
                maxAge = "7776000"; # 90 days
              };
            };
          };
        };
      };
    };
  };
}
