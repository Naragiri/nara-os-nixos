{ lib, config, inputs, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.system.boot.lanzaboote;
in {
  imports = with inputs; [ lanzaboote.nixosModules.lanzaboote ];

  options.nos.system.boot.lanzaboote = with types; {
    enable = mkEnableOption "Enable lanzaboote (secure boot).";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ sbctl ];

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}
