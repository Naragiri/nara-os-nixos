{ lib, config, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.cli-apps.fastfetch;
in {
  options.nos.cli-apps.fastfetch = with types; {
    enable = mkEnableOption "Enable fastfetch.";
  };

  config = mkIf cfg.enable {
    environment.shellAliases = { "nf" = "${getExe pkgs.fastfetch}"; };
    nos.home.configFile."fastfetch/config.jsonc".text = import ./config.nix;
    # nos.home.file.".local/share/fastfetch/logos/snowflake".source = ./logo.png;
  };
}
