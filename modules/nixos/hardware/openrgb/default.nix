{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    getExe
    ;
  cfg = config.nos.hardware.openrgb;

  no-rgb = pkgs.writeShellScriptBin "no-rgb" ''
    device_count=$(${getExe cfg.package} --list-devices | grep -c "^[0-9]")
    for i in $(seq 0 $((device_count - 1))); do
      ${getExe cfg.package} --device $i --mode Static --color 000000
    done
  '';
in
{
  options.nos.hardware.openrgb = {
    enable = mkEnableOption "Enable openrgb.";
    no-rgb.enable = mkEnableOption "Enable systemd service to automatically turn-off all rgb.";
    package = mkOption {
      type = types.package;
      default = pkgs.openrgb-with-all-plugins;
      description = "The OpenRGB package to use.";
    };
  };

  config = mkIf cfg.enable {
    hardware.i2c.enable = true;

    boot.kernelModules = [
      "i2c-dev"
      "i2c-piix4"
      "i2c-nct6775"
    ];
    boot.kernelParams = [
      "acpi_enforce_resources=lax"
      "acpi_osi=Linux"
      "pcie_aspm=off"
    ];

    nos.user.extraGroups = [
      "i2c"
      "video"
    ];

    services.udev.packages = [ cfg.package ];

    services.udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
      SUBSYSTEM=="i2c-dev", GROUP="i2c", MODE="0660"
      SUBSYSTEM=="i2c-dev", KERNEL=="i2c-[0-9]*", ATTR{name}=="AMDGPU*", GROUP="i2c", MODE="0660"
      SUBSYSTEM=="i2c-dev", KERNEL=="i2c-[0-9]*", ATTR{name}=="SMBus*", GROUP="i2c", MODE="0660"
    '';

    systemd.services.openrgb = {
      description = "OpenRGB server daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${getExe cfg.package} --server --server-port ${toString config.services.hardware.openrgb.server.port} --verbose";
        Restart = "always";
        User = config.nos.user.name;
      };
    };

    environment.systemPackages = [ cfg.package ];

    systemd.services.no-rgb = mkIf cfg.no-rgb.enable {
      description = "no-rgb";
      serviceConfig = {
        ExecStart = "${getExe no-rgb}";
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
