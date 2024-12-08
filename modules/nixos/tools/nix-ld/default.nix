{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.nos) enabled;
  cfg = config.nos.tools.nix-ld;
in
{
  imports = [ inputs.nix-ld.nixosModules.nix-ld ];

  options.nos.tools.nix-ld = {
    enable = mkEnableOption "Enable nix-ld.";
  };

  config = mkIf cfg.enable { programs.nix-ld.dev = enabled; };
}
