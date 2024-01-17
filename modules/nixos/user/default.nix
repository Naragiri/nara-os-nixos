{ lib, config, options, pkgs, ... }:
with lib;
let
  cfg = config.nos.system.user;
in
{
  options.nos.system.user = with types; {
    name = mkOption {
      type = str;
      default = "nara";
      description = "The name to use for the main user account.";
    };
    initialPassword  = mkOption {
      type = str;
      default = "123";
      description = "The initial password for the main user account.";
    };
    extraGroups  = mkOption {
      type = (listOf str);
      default = [];
      description = "Extra groups for the main user account.";
    };
  };

  config = {
    environment.sessionVariables = {
      FLAKE_DIR = "/home/${cfg.name}/nara-os-nixos";
      PATH = [
        "$HOME/.local/bin"
      ];
    };

    environment.shellAliases = { "nix-update" = "nixos-rebuild switch --flake $FLAKE_DIR#"; };

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