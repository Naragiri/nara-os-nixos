{
  options,
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkOption types mkAliasDefinitions;
  inherit (lib.nos) enabled;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.nos.home = {
    configFile = mkOption {
      default = { };
      description = "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
      type = types.attrs;
    };
    extraOptions = mkOption {
      default = { };
      description = "Options to pass directly to home-manager.";
      type = types.attrs;
    };
    file = mkOption {
      default = { };
      description = "A set of files to be managed by home-manager's <option>home.file</option>.";
      type = types.attrs;
    };
  };

  config = {
    nos.home.extraOptions = {
      programs.home-manager = enabled;
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.nos.home.file;
      xdg = enabled // {
        configFile = mkAliasDefinitions options.nos.home.configFile;
        mime = enabled;
        mimeApps = enabled;
      };
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.nos.user.name} = mkAliasDefinitions options.nos.home.extraOptions;
    };
  };
}
