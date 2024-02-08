{ options, config, lib, inputs,... }:

with lib;
with lib.nos;
{
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  options.home = with types; {
    file = mkOpt attrs {} "A set of files to be managed by home-manager's <option>home.file</option>.";
    configFile = mkOpt attrs {} "A set of files to be managed by home-manager's <option>xdg.configFile</option>.";
    extraOptions = mkOpt attrs {} "Options to pass directly to home-manager.";
  };

    config = {
      home.extraOptions = {
        home.stateVersion = config.system.stateVersion;
        home.file = mkAliasDefinitions options.home.file;
        xdg.enable = true;
        xdg.configFile = mkAliasDefinitions options.home.configFile;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.nos.system.user.name} = mkAliasDefinitions options.home.extraOptions;
    };
  };
}