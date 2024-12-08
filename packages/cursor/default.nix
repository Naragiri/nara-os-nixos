{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  electron,
  makeWrapper,
}:

let
  downloadUrl = "https://downloader.cursor.sh/linux/appImage/x64";
in
stdenv.mkDerivation rec {
  pname = "cursor";
  version = "0.39.6";

  src = fetchurl {
    url = downloadUrl;
    sha256 = "sha256-huZTzIZFAYtGRMhXGC+1sd0l2s5913QkWM+QjCtsEl0=";
  };

  appimageContents = appimageTools.extractType1 {
    inherit src;
    name = "${pname}-${version}";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp -r ${appimageContents}/locales $out/share/${pname}/
    cp -r ${appimageContents}/resources $out/share/${pname}/
    cp -r ${appimageContents}/usr/share/icons $out/share/
    cp -a ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}" \
      --add-flags "--app=$out/share/${pname}/resources/app" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';
}
