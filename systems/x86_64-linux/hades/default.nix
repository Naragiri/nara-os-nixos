{ pkgs, inputs, lib, ... }:
with lib;
with lib.nos; {
  imports = with inputs; [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.common-gpu-amd
  ];

  nos = {
    apps = {
      brave = enabled;
      chatterino = enabled;
      discord = enabled;
      emulators = {
        citra = enabled;
        dolphin = enabled;
        pcsx2 = enabled;
        yuzu = enabled;
      };
      firefox = enabled;
      launchers = {
        heroic = enabled;
        lutris = enabled;
      };
      minecraft = enabled;
      nemo = enabled;
      pqiv = enabled;
      qbittorrent = enabled;
      spotify = enabled;
      steam = enabled // {
        protonup = enabled;
        rom-manager = enabled;
        steamos = enabled;
      };
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
      snixembed = enabled;
    };
    desktop.awesome = enabled;
    hardware = {
      audio = enabled;
      bluetooth = enabled;
      network = enabled;
      openrgb = enabled // { no-rgb = enabled; };
      ssd = enabled;
    };
    services = {
      flatpak = enabled;
      openssh = enabled;
    };
    system = {
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
    virtualisation.qemu = enabled // { vfio = enabled; };
  };

  services.xserver.displayManager.setupCommands = with pkgs; ''
    ${
      getExe xorg.xrandr
    } --output DP-1 --primary --mode 2560x1440 --output DP-2 --mode 2560x1440 --left-of DP-1 --output HDMI-1 --off
  '';

  system.stateVersion = "23.11";
}
