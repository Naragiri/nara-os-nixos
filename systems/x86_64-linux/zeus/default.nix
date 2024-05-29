{ pkgs, inputs, lib, ... }:
with lib;
with lib.nos; {
  imports = with inputs; [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.framework-16-7040-amd
  ];

  nos = {
    apps = {
      discord = enabled;
      chromium = enabled;
      easyeffects = enabled // {
        preset =
          "ee_bryan_preset"; # https://community.frame.work/t/framework-16-sound-quality/46635
      };
      firefox = enabled // { makeDefaultBrowser = true; };
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
      xivlauncher = enabled;
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
      syncthing = enabled;
    };
    system = {
      battery = enabled;
      boot = {
        plymouth = enabled;
        lanzaboote = enabled;
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

  services.xserver.displayManager.setupCommands = with pkgs; ''
    ${getExe xorg.xrandr} --output eDP-2 --scale 0.8x0.8
  '';

  services.fwupd.enable = true;

  system.stateVersion = "23.11";
}
