{ lib, ... }:
let
  inherit (lib) types;
in
{
  mkEnabledOption =
    description:
    lib.mkOption {
      inherit description;
      type = types.bool;
      default = true;
    };

  enabled = {
    enable = true;
  };

  disabled = {
    enable = false;
  };

  # For hyprland
  createUWSMCommand = command: "uwsm app -- ${command}";

  recursiveMergeAttrs =
    attrLists:
    let
      inherit (lib)
        zipAttrsWith
        tail
        head
        all
        isList
        unique
        concatLists
        isAttrs
        last
        ;

      f =
        attrPath:
        zipAttrsWith (
          n: values:
          if tail values == [ ] then
            head values
          else if all isList values then
            unique (concatLists values)
          else if all isAttrs values then
            f (attrPath ++ [ n ]) values
          else
            last values
        );
    in
    f [ ] attrLists;
}
