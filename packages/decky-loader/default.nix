{
  pkgs,
  stdenv,
  ...
}:
let
  pname = "decky-loader";
  source = (pkgs.callPackages ./generated.nix { }).${pname};
  version = builtins.substring 1 (builtins.stringLength source.version - 1) source.version;
in
stdenv.mkDerivation {
  inherit pname version;
  inherit (source) src;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 $src $out/bin/PluginLoader

    runHook postInstall
  '';
}
