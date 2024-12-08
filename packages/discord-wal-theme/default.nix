{
  pkgs,
  stdenvNoCC,
}:
let
  pname = "discord-wal-theme";
  source = (pkgs.callPackages ./generated.nix { }).${pname};
in
stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  installPhase = ''
    mkdir -p $out
    cp -aR $src/* $out
  '';
}
