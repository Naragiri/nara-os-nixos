{ lib, stdenvNoCC }:
stdenvNoCC.mkDerivation rec {
  name = "nos-wallpapers";
  src = ./wallpapers;

  installPhase = ''
    mkdir -p $out
    cp -aR $src/* $out
  '';
}
