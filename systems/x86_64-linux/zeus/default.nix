{ pkgs, inputs, lib, ... }:
with lib;
with lib.nos; {
  imports = with inputs; [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.framework-16-7040-amd
  ];

  nos = {
    apps = {
      brave = enabled;
      discord = enabled;
      firefox = enabled;
      minecraft = enabled;
      nemo = enabled;
      pqiv = enabled;
      qbittorrent = enabled;
      spotify = enabled;
      steam = enabled // { protonup = enabled; };
      vscode = enabled // {
        theme = enabled // {
          name = "Just Black";
          package = pkgs.nos.vscode-just-black;
        };
      };
    };
    cli-apps = {
      ani-cli = enabled;
      fastfetch = enabled;
      lf = enabled;
    };
    desktop.awesome = enabled;
    hardware = {
      audio = enabled;
      bluetooth = enabled;
      network = enabled;
      ssd = enabled;
    };
    services = {
      flatpak = enabled;
      openssh = enabled;
    };
    system = {
      battery = enabled;
      boot = {
        plymouth = enabled;
        systemd = enabled;
      };
      security = { doas = enabled; };
    };
    tools = {
      common = enabled;
      direnv = enabled;
      disko = enabled;
      nix-ld = enabled;
      git = enabled;
      qmk = enabled;
      zoxide = enabled;
    };
  };

  services.fwupd.enable = true;

  system.stateVersion = "23.11";
}
