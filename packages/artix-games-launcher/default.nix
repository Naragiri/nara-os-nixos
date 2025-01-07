{
  appimageTools,
  imagemagick,
  fetchurl,
}:

let
  pname = "artix-games-launcher";
  version = "2.1.2";
  downloadUrl = "https://launch.artix.com/latest/Artix_Games_Launcher-x86_64.AppImage";

  src = fetchurl {
    url = downloadUrl;
    sha256 = "sha256-U9o8GGdh8TZ/bJFcUGOhQXIhnNdd9rsoSP71XXPORWE=";
  };

  appimageContents = appimageTools.extractType1 {
    inherit pname src version;
  };
in
appimageTools.wrapType1 {
  inherit pname src version;

  nativeBuildInputs = [
    imagemagick
  ];

  extraInstallCommands = ''
    mkdir -p  $out/share/icons $out/share/applications
    cp -a ${appimageContents}/ArtixGamesLauncher.desktop $out/share/applications/${pname}.desktop

    for i in 16 24 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      convert -background none -resize ''${i}x''${i} -alpha on -flatten ${appimageContents}/resources/icons/icon.ico $out/share/icons/hicolor/''${i}x''${i}/apps/${pname}.png
    done

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=ArtixGameLauncher' 'Exec=${pname}' \
      --replace 'Icon=ArtixLogo' 'Icon=${pname}'
  '';
}
