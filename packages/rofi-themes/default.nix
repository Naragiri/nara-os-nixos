{
  pkgs,
  stdenvNoCC,
}:
let
  pname = "rofi-themes";
  source = (pkgs.callPackages ./generated.nix { }).${pname};
in
stdenvNoCC.mkDerivation {
  inherit (source) pname version src;

  buildInputs = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.iosevka
  ];

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
