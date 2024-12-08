{
  pkgs,
  lib,
  stdenvNoCC,
  variant ? "Dark",
  colorVariant ? "Blue",
}:
let
  pname = "skeuos-gtk-theme";
  source = (pkgs.callPackages ./generated.nix { }).${pname};

  validVariants = [
    "Dark"
    "Light"
  ];
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
in
lib.checkListOfEnum "${pname}: variant" validVariants [ variant ] lib.checkListOfEnum
  "${pname}: colorVariant"
  validColorVariants
  [ colorVariant ]

  stdenvNoCC.mkDerivation
  {
    inherit (source) pname version src;

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
