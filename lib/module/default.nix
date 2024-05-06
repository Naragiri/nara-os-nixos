{ lib, ... }:
with lib; rec {
  mkOpt = type: default: description:
    mkOption { inherit type default description; };

  mkNullOpt = type: default: description:
    mkOption {
      inherit default description;
      type = types.nullOr type;
    };

  mkBoolOpt = mkOpt types.bool;

  mkStrOpt = mkOpt types.str;

  mkNumOpt = mkOpt types.int;

  mkEnabledOption = mkBoolOpt true;

  enabled = { enable = true; };

  disabled = { enable = false; };
}
