{ lib, pkgs, ... }:
let
  pname = "xivlauncher-rb";
  source = (pkgs.callPackages ./generated.nix { }).${pname};
  version = builtins.substring 4 (builtins.stringLength source.version - 4) source.version;

in
pkgs.xivlauncher.overrideAttrs (oldAttrs: {
  inherit pname version;
  inherit (source) src;

  dotnetFlags = [
    "-p:BuildHash=${version}"
    "-p:PublishSingleFile=false"
  ];

  # don't need it.
  postPatch = "";

  postFixup =
    let
      gamemode-path = lib.makeLibraryPath [ pkgs.gamemode ];
    in
    oldAttrs.postFixup
    + ''
      wrapProgram $out/bin/XIVLauncher.Core \
        --prefix LD_PRELOAD : ${gamemode-path}/libgamemodeauto.so \
        --prefix LD_PRELOAD : ${gamemode-path}/libgamemode.so
    '';
})
