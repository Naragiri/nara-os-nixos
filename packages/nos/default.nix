{
  lib,
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  name = "nos";
  src = ./.;

  nativeBuildInputs = with pkgs; [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    pkgs.nix-output-monitor
    pkgs.fd
    pkgs.nvd
    pkgs.nvfetcher
  ];

  installPhase = ''
    install -Dm755 ${name} $out/bin/${name}

    wrapProgram $out/bin/${name} \
      --prefix PATH : '${lib.makeBinPath buildInputs}'

    installShellCompletion --zsh completions/nos.zsh
  '';
}
