{ lib, config, pkgs, ... }:

with lib;
with lib.nos;
let
  cfg = config.nos.hardware.gpu.amd;
in
{
  options.nos.hardware.gpu.amd.enable = mkEnableOption "Enable amdgpu module.";

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "amdgpu" ];

    services.xserver = mkIf config.services.xserver.enable {
      videoDrivers = [ "amdgpu" ];
    };

    hardware.opengl = {
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
  };
}