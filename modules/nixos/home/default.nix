{ options, config, lib, inputs, ... }:
with lib;
with lib.nos; {
  imports = with inputs; [ home-manager.nixosModules.home-manager ];

  options.nos.home = with types; {
    configFile = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs { } "Options to pass directly to home-manager.";
    file = mkOpt attrs { }
      "A set of files to be managed by home-manager's <option>home.file</option>.";
  };

  config = {
    nos.home.extraOptions = {
      programs.home-manager = enabled;
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.nos.home.file;
      xdg.enable = true;
      xdg.mime.enable = true;
      xdg.mimeApps.enable = true;
      xdg.configFile = mkAliasDefinitions options.nos.home.configFile;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.nos.user.name} =
        mkAliasDefinitions options.nos.home.extraOptions;
    };
  };
}
