{ lib, config, options, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.system.user;
in
{
  options.nos.system.user = with types; {
    name = mkStrOpt "nara" "The name to use for the main user account.";
    initialPassword  = mkStrOpt "123" "The initial password for the main user account.";
    extraGroups = mkOpt (listOf str) [] "Extra groups for the main user account.";
  };

  config = {
    environment.sessionVariables.FLAKE_DIR = "/home/${cfg.name}/naraos-nixos-flake";
    
    home = {
      file = {
        "Documents/.keep".text = "";
        "Downloads/.keep".text = "";
        "Music/.keep".text = "";
        "Pictures/.keep".text = "";
        "Repos/.keep".text = "";
      };
    };

    users.users.${cfg.name} = {
      inherit (cfg) name initialPassword;
      isNormalUser = true;
      home = "/home/${cfg.name}";
      uid = 1000;
      group = "users";
      packages = with pkgs; [
        vim  
        nano
      ];
      extraGroups = [ "wheel" "audio" "sound" "video" "networkmanager" "input" "tty" "docker" ] 
        ++ cfg.extraGroups;
    };
  };
}