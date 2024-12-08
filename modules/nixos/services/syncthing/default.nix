{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    mapAttrs
    ;
  inherit (lib.nos) enabled;
  cfg = config.nos.services.syncthing;

  defaultVersioning = {
    type = "staggered";
    params = {
      cleanInterval = "3600"; # 1 hour
      maxAge = "7776000"; # 90 days
    };
  };
in
{

  options.nos.services.syncthing = {
    enable = mkEnableOption "Enable syncthing.";
    extraFolders = mkOption {
      default = { };
      description = "Extra folders to sync.";
      type = types.attrsOf (
        types.submodule {
          options = {
            path = mkOption {
              default = "";
              description = "The path to sync from/to.";
              type = types.str;
            };
            devices = mkOption {
              default = [ ];
              description = "The devices to sync to.";
              type = types.listOf types.str;
            };
            versioning = mkOption {
              default = {
                type = "staggered";
                params = {
                  cleanInterval = "3600"; # 1 hour
                  maxAge = "7776000"; # 90 days
                };
              };
              description = "The versioning options.";
              type = types.attrs;
            };
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {
    services.syncthing =
      let
        user = config.nos.user.name;
        inherit (config.users.users.${user}) group;
      in
      enabled
      // {
        inherit user group;
        dataDir = "/home/${user}/.syncthing";
        configDir = "/home/${user}/.config/syncthing";
        openDefaultPorts = true;
        settings = {
          devices = {
            "hades" = {
              id = "NPFCSL2-FDX65IN-6757H2F-6BBOONP-RX77E5C-3UQGUBF-MSUB43U-VUCWCQF";
            };
            "zeus" = {
              id = "4UBD4LD-AUTHPUL-UFMZWM7-NIGYI4E-RT4X7WC-WGUYPA5-MXZGYQD-6W6A6QH";
            };
          };
          folders = {
            "Repos" = {
              path = "/home/${user}/Repos";
              devices = [
                "hades"
                "zeus"
              ];
              versioning = defaultVersioning;
            };
          } // (mapAttrs (_name: attrs: { inherit (attrs) path devices versioning; }) cfg.extraFolders);
        };
      };
  };
}
