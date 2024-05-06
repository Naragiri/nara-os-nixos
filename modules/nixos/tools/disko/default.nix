{ inputs, lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.tools.disko;
in {
  imports = with inputs; [ disko.nixosModules.disko ];

  options.nos.tools.disko = with types; {
    enable = mkEnableOption "Enable disko.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ disko ]; };
}
