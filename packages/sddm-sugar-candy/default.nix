{ pkgs, lib, stdenvNoCC, crudini, themeConfig ? null }:

let
  pname = "sddm-sugar-candy";
  source = (pkgs.callPackages ./generated.nix { }).${pname};

  user-cfg = (pkgs.formats.ini { }).generate "theme.conf.user" themeConfig;
in stdenvNoCC.mkDerivation rec {
  inherit (source) pname version src;

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/sugar-candy/
    cp -r * $out/share/sddm/themes/sugar-candy/
  '' + lib.optionalString (lib.isAttrs themeConfig) ''
    ln -sf ${user-cfg} $out/share/sddm/themes/sugar-candy/theme.conf.user
  '';
}
