{ lib, ... }:
final: prev: {
  xivlauncher = prev.xivlauncher.overrideAttrs (oldAttrs: {
    runtimeDeps = oldAttrs.runtimeDeps ++ [ prev.gamemode ];

    postFixup = oldAttrs.postFixup + ''
      wrapProgram $out/bin/XIVLauncher.Core \
        --prefix LD_PRELOAD : ${
          lib.makeLibraryPath [ prev.gamemode ]
        }/libgamemodeauto.so
    '';
  });
}
