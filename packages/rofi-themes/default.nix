{ pkgs, lib, nerdfonts, stdenvNoCC }:
let
  pname = "rofi-themes";
  source = (pkgs.callPackages ./generated.nix { }).${pname};
in stdenvNoCC.mkDerivation rec {
  inherit (source) pname version src;

  buildInputs =
    [ (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; }) ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/files
    cp -r $src/files $out
    mkdir -p $out/share/fonts
    cp $src/fonts/Icomoon-Feather.ttf $out/share/fonts/Icomoon-Feather.ttf

    runHook postInstall
  '';

  meta.mainProgram = "rofi-themes";
}
