{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nos.apps.firefox.betterfox;

  jsonToAttrs =
    file:
    let
      json = builtins.fromJSON file;
      attrList = builtins.map (key: {
        inherit key;
        value = json."${key}";
      }) (builtins.attrNames json);
    in
    builtins.listToAttrs (
      map (p: {
        name = p.key;
        inherit (p) value;
      }) attrList
    );
in
{
  options.nos.apps.firefox.betterfox = {
    enable = mkEnableOption "Enable betterfox (firefox privacy user.js).";
  };

  config = mkIf cfg.enable {
    nos.apps.firefox = {
      # Too many weird defaults
      # extraPolicies = (jsonToAttrs (builtins.readFile "${pkgs.nos.betterfox}/policies.json")).policies;
      extraSettings = jsonToAttrs (builtins.readFile "${pkgs.nos.betterfox}/betterfox.json");
    };
  };
}
