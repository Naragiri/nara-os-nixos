{
  lib,
  pkgs,
  pango,
  extraGIPackages ? [ ],
  ...
}:
let
  pname = "awesome";
  source = (pkgs.callPackages ./generated.nix { }).${pname};

  mkAwesome =
    name:
    (pkgs.awesome.override { gtk3Support = true; }).overrideAttrs (oldAttrs: {
      inherit (source) version src;
      pname = name;

      GI_TYPELIB_PATH =
        let
          mkTypeLibPath = pkg: "${pkg}/lib/girepository-1.0";
          extraGITypeLibPaths = lib.forEach extraGIPackages mkTypeLibPath;
        in
        lib.concatStringsSep ":" (extraGITypeLibPaths ++ [ (mkTypeLibPath pango.out) ]);

      patches = [ ];

      postPatch = ''
        patchShebangs tests/examples/_postprocess.lua
        patchShebangs tests/examples/_postprocess_cleanup.lua
      '';

      cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DGENERATE_MANPAGES=OFF" ];

      meta = oldAttrs.meta // {
        mainProgram = pname;
      };
    });
in
{
  awesome-git = mkAwesome "awesome-git";
  awesome-luajit-git = (mkAwesome "awesome-luajit-git").override { lua = pkgs.luajit; };
}
