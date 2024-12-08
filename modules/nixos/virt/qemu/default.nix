{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    types
    optionalString
    concatStringsSep
    length
    ;
  inherit (lib.nos) enabled;
  cfg = config.nos.virtualisation.qemu;
in
{
  options.nos.virtualisation.qemu = {
    enable = mkEnableOption "Enable qemu and virt-manager.";
    vfio = {
      enable = mkEnableOption "Enable vfio for hardware passthrough.";
      vfioIds = mkOption {
        default = [ ];
        description = "The hardware IDs to pass through.";
        type = types.listOf types.str;
      };
      cpuPlatform = mkOption {
        # TODO: change this to use the same as microcode.
        default = "intel";
        description = "Which CPU platform the machine is using.";
        type = types.enum [
          "amd"
          "intel"
        ];
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs.virt-manager = enabled;

      virtualisation.libvirtd = enabled // {
        extraConfig = ''
          user="${config.nos.user.name}"
        '';
        onBoot = "ignore";
        onShutdown = "shutdown";

        qemu = {
          ovmf = enabled;
          swtpm = enabled;
          verbatimConfig = ''
            namespaces = []
            user = "+${builtins.toString config.users.users.${config.nos.user.name}.uid}"
          '';
        };
      };

      nos.user.extraGroups = [
        "qemu-libvirtd"
        "libvirtd"
      ];
    })
    (mkIf cfg.vfio.enable {
      boot = {
        kernelModules = [
          "kvm-${cfg.vfio.cpuPlatform}"
          "vfio_virqfd"
          "vfio_pci"
          "vfio_iommu_type1"
          "vfio"
        ];
        kernelParams = [
          "${cfg.vfio.cpuPlatform}_iommu=on"
          "${cfg.vfio.cpuPlatform}_iommu=pt"
          "kvm.ignore_msrs=1"
        ];
        extraModprobeConfig = optionalString (length cfg.vfio.vfioIds > 0) ''
          softdep amdgpu pre: vfio vfio-pci
          options vfio-pci ids=${concatStringsSep "," cfg.vfio.vfioIds}
        '';
      };
    })
  ];
}
