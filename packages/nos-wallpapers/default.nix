{
  pkgs,
  stdenvNoCC,
  ...
}:
let
  name = "nos-wallpapers";
  source = (pkgs.callPackages ./generated.nix { }).${name};
in
stdenvNoCC.mkDerivation {
  inherit name;
  inherit (source) src;

  installPhase = ''
    mkdir -p $out
    cp -aR $src/* $out
  '';
}
