{ pkgs, fetchFromGitHub, ... }:
pkgs.picom.overrideAttrs (oldAttrs: rec {
  pname = "compfy";
  version = "1.7.2";

  src = pkgs.fetchFromGitHub {
    owner = "allusive-dev";
    repo = "compfy";
    rev = version;
    sha256 = "7hvzwLEG5OpJzsrYa2AaIW8X0CPyOnTLxz+rgWteNYY=";
  };

  buildInputs = with pkgs; [ pcre2 ] ++ oldAttrs.buildInputs;
  postInstall = "";

  # make nix not use picom as the binary name.
  meta.mainProgram = "compfy";
})
