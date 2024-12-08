{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.tools.disko;
in
{
  imports = [ inputs.disko.nixosModules.disko ];

  options.nos.tools.disko = {
    enable = mkEnableOption "Enable disko.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ inputs.disko.packages.${pkgs.system}.disko ];
  };
}
