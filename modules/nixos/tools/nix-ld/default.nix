{ inputs, lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.tools.nix-ld;
in {
  imports = with inputs; [ nix-ld.nixosModules.nix-ld ];

  options.nos.tools.nix-ld = with types; {
    enable = mkEnableOption "Enable nix-ld.";
  };

  config = mkIf cfg.enable { programs.nix-ld.enable = true; };
}
