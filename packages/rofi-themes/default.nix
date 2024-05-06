{ fetchFromGitHub, lib, nerdfonts, stdenvNoCC }:
stdenvNoCC.mkDerivation rec {
  pname = "rofi-themes";
  version = "1.7.4";
  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "7e236dd67fd98304e1be9e9adc2bed9106cf895b";
    sha256 = "K6WQ+olSy6Rorof/EGi9hP2WQpRONjuGREby+aBlzYg=";
    fetchSubmodules = false;
  };

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
