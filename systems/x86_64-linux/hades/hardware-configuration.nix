{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "nohibernate" ];
    supportedFilesystems = [ "ntfs" ];
    tmp.cleanOnBoot = true;
  };

  networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/62d5cc75-7bd2-4051-a836-ed0ca754759b";
    fsType = "f2fs";
    options = [
      "noatime"
      "nofail"
      "users"
      "x-gvfs-show"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
