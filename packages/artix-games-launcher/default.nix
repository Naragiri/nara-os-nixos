{
  appimageTools,
  imagemagick,
  fetchurl,
}:

let
  name = "artix-games-launcher";
  version = "2.1.2";
  downloadUrl = "https://launch.artix.com/latest/Artix_Games_Launcher-x86_64.AppImage";

  src = fetchurl {
    url = downloadUrl;
    sha256 = "sha256-U9o8GGdh8TZ/bJFcUGOhQXIhnNdd9rsoSP71XXPORWE=";
  };

  appimageContents = appimageTools.extractType1 {
    inherit src;
    name = "${name}-${version}";
  };
in
appimageTools.wrapType1 {
  inherit name src;

  nativeBuildInputs = [
    imagemagick
  ];

  extraInstallCommands = ''
    mkdir -p  $out/share/icons $out/share/applications
    cp -a ${appimageContents}/ArtixGamesLauncher.desktop $out/share/applications/${name}.desktop

    for i in 16 24 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      convert -background none -resize ''${i}x''${i} -alpha on -flatten ${appimageContents}/resources/icons/icon.ico $out/share/icons/hicolor/''${i}x''${i}/apps/${name}.png
    done

    substituteInPlace $out/share/applications/${name}.desktop \
      --replace 'Exec=ArtixGameLauncher' 'Exec=${name}' \
      --replace 'Icon=ArtixLogo' 'Icon=${name}'
  '';
}
