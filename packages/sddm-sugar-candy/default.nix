{ fetchFromGitHub, pkgs, lib, stdenvNoCC, crudini, themeConfig ? null }:

let user-cfg = (pkgs.formats.ini { }).generate "theme.conf.user" themeConfig;
in stdenvNoCC.mkDerivation rec {
  pname = "sddm-sugar-candy";
  version = "a1fae5159c8f7e44f0d8de124b14bae583edb5b8";
  src = fetchFromGitHub {
    owner = "Kangie";
    repo = pname;
    rev = version;
    sha256 = "p2d7I0UBP63baW/q9MexYJQcqSmZ0L5rkwK3n66gmqM=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/sugar-candy/
    cp -r * $out/share/sddm/themes/sugar-candy/
  '' + lib.optionalString (lib.isAttrs themeConfig) ''
    ln -sf ${user-cfg} $out/share/sddm/themes/sugar-candy/theme.conf.user
  '';
}
