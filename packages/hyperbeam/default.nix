{
  lib,
  fetchurl,
  appimageTools
}:

let
  pname = "hyperbeam";
  version = "0.21.0";

  src = fetchurl {
    url = "https://cdn.hyperbeam.com/Hyperbeam-0.21.0.AppImage";
    sha256 = "sha256-7UYxtbqT65CAdngmrIq4290Ny8sCybt4FQgbUZHMd7I=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications

    mv $out/bin/${pname}-${version} $out/bin/${pname}
    cp -a ${appimageContents}/hyperbeam.desktop $out/share/applications
    cp -aR ${appimageContents}/usr/share/icons $out/share/icons

    # currently unusable due to nix not allowing permission to this file.
    # substituteInPlace ${appimageContents}/resources/assets/xdg.desktop --replace \
    #   'Exec=' 'Exec=${pname}'

    substituteInPlace $out/share/applications/hyperbeam.desktop --replace \
      'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
  '';
}