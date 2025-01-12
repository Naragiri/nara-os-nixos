{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.system.boot.lanzaboote;
in
{
  imports = with inputs; [ lanzaboote.nixosModules.lanzaboote ];

  options.nos.system.boot.lanzaboote = {
    enable = mkEnableOption "Enable lanzaboote (secure boot).";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sbctl ];

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = enabled // {
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
