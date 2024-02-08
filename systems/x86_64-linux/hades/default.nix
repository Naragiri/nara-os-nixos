{ lib, ... }:

with lib.nos;
{
  imports = [ ./hardware-configuration.nix ];

  nos = { 
    apps = {
      editor.vscode = enabled;
      media.spotify = enabled;
      misc.neofetch = enabled;
      games = {
        minecraft = enabled;
        steam = {
          enable = true;
          consoleSession = enabled;
        };
        common.launchers = enabled;
      };
      social.discord = enabled;
      tools = {
        common = enabled;
        nix-ld = enabled;
        git = enabled;
      };
      web.librewolf = enabled;
      web.vivaldi = enabled;
    };
    desktop.plasma5 = enabled;
    hardware = {
      audio = enabled;
      bluetooth = enabled;
      gpu.amd = enabled;
      network = enabled;
      openrgb = {
        enable = true;
        no-rgb = enabled;
      };
    };
    system = {
      boot.grub = enabled;
      security.doas = enabled;
      service.flatpak = enabled;
    };
  };

  services.openssh.enable = true;
  # networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = true;

  system.stateVersion = "23.11";
}
