{ fetchFromGitHub, lib, nerdfonts, stdenvNoCC, variant ? "Dark"
, colorVariant ? "Blue" }:
let
  pname = "skeuos-gtk-theme";
  validVariants = [ "Dark" "Light" ];
  validColorVariants = [
    "Blue"
    "Green"
    "Red"
    "Yellow"
    "Black"
    "Brown"
    "Cyan"
    "Grey"
    "Magenta"
    "Orange"
    "Tea"
    "Violet"
    "White"
  ];
in lib.checkListOfEnum "${pname}: variant" validVariants [ variant ]
lib.checkListOfEnum "${pname}: colorVariant" validColorVariants [ colorVariant ]

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "20220629";
  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = "skeuos-gtk";
    rev = "de8a4b1c7182b9f0a20b17298f4eee927ba6d156";
    sha256 = "sha256-cfVe6/M64wcf0WVbC+sGwsZjg9t70+5+lIf5j5fqz2w=";
    fetchSubmodules = false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    cp -r $src/themes/Skeuos-${colorVariant}-${variant} $out/share/themes

    runHook postInstall
  '';

  meta.mainProgram = "rofi-themes";
}
