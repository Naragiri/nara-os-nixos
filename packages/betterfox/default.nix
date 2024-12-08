{ pkgs, stdenvNoCC, ... }:
let
  name = "betterfox";
  source = (pkgs.callPackages ./generated.nix { }).${name};

  betterfox-extractor = ./extractor.py;
in
# extractor = pkgs.writeShellApplication {
#   name = "betterfox-extractor";
#   # runtimeInputs = [ pkgs.python3 ];
#   text = "${pkgs.python3}/bin/python3 ${extractor} $INPUT_FILE > $out";
# };

stdenvNoCC.mkDerivation {
  inherit name;
  inherit (source) src;

  installPhase = ''
    mkdir -p $out
    # cp -a $src/policies.json $out
    ${pkgs.python3}/bin/python3 ${betterfox-extractor} $src/user.js > $out/betterfox.json
  '';
}
