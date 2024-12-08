{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mapAttrs
    isList
    concatMapStringsSep
    concatStringsSep
    mapAttrsToList
    ;
  cfg = config.nos.system.env;
in
{
  options.nos.system.env = mkOption {
    type = types.attrsOf (
      types.oneOf [
        types.str
        types.path
        (types.listOf (types.either types.str types.path))
      ]
    );
    apply = mapAttrs (_n: v: if isList v then concatMapStringsSep ":" toString v else (toString v));
    default = { };
    description = "A set of environment variables to set.";
  };

  config = {
    environment = rec {
      sessionVariables = {
        XDG_CACHE_HOME = "/home/${config.nos.user.name}/.cache";
        XDG_CONFIG_HOME = "/home/${config.nos.user.name}/.config";
        XDG_DATA_HOME = "/home/${config.nos.user.name}/.local/share";
        XDG_BIN_HOME = "/home/${config.nos.user.name}/.local/bin";
        # To prevent firefox from creating ~/Desktop.
        XDG_DESKTOP_DIR = "/home/${config.nos.user.name}";

        PATH = [ "${sessionVariables.XDG_BIN_HOME}" ];
      };
      extraInit = concatStringsSep "\n" (mapAttrsToList (n: v: ''export ${n}="${v}"'') cfg);
    };
  };
}
