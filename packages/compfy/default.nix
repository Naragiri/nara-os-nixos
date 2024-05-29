{ pkgs, ... }:
let
  pname = "compfy";
  source = (pkgs.callPackages ./generated.nix { }).${pname};
in pkgs.picom.overrideAttrs (oldAttrs: rec {
  inherit (source) pname version src;

  buildInputs = with pkgs; [ pcre2 ] ++ oldAttrs.buildInputs;
  postInstall = "";

  # make nix not use picom as the binary name.
  meta.mainProgram = "compfy";
})
