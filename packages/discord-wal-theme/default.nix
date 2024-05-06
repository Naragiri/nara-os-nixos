{ fetchFromGitHub, lib, nerdfonts, stdenvNoCC }:
stdenvNoCC.mkDerivation rec {
  pname = "discord-wal-theme";
  version = "ed05ae5f3b2ce28588c21d4561ff2c6ed74926d7";
  src = fetchFromGitHub {
    owner = "Gremious";
    repo = "discord-wal-theme-template";
    rev = version;
    sha256 = "sha256-+DSZJwy6pSIG5T6dLQjcFoIVEvJtZ45rcGzNVZ6BsEg=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out
  '';
}
