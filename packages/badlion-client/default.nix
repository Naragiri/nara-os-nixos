{
  lib,
  fetchurl,
  appimageTools
}:

let
  pname = "badlion-client";
  version = "3.15.0";

  src = fetchurl {
    url = "https://client-updates-cdn77.badlion.net/BadlionClient";
    sha256 = "sha256-qI/5eNgaDgyLC9NOrHaDkITZsYsBLTOyqzGwobUDKh8=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications

    mv $out/bin/${pname}-${version} $out/bin/${pname}
    cp -a ${appimageContents}/BadlionClient.desktop $out/share/applications
    cp -aR ${appimageContents}/usr/share/icons $out/share/icons

    substituteInPlace $out/share/applications/BadlionClient.desktop --replace \
      'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
  '';
}