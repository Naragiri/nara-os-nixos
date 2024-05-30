{ lib, pkgs, pango, extraGIPackages ? [ ], ... }:
let
  pname = "awesome";
  source = (pkgs.callPackages ./generated.nix { }).${pname};
in (pkgs.awesome.override {
  lua = pkgs.luajit;
  gtk3Support = true;
}).overrideAttrs (oldAttrs: rec {
  inherit (source) pname version src;

  GI_TYPELIB_PATH = let
    mkTypeLibPath = pkg: "${pkg}/lib/girepository-1.0";
    extraGITypeLibPaths = lib.forEach extraGIPackages mkTypeLibPath;
  in lib.concatStringsSep ":"
  (extraGITypeLibPaths ++ [ (mkTypeLibPath pango.out) ]);

  patches = [ ];

  postPatch = ''
    patchShebangs tests/examples/_postprocess.lua
    patchShebangs tests/examples/_postprocess_cleanup.lua
  '';

  cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DGENERATE_MANPAGES=OFF" ];
})
