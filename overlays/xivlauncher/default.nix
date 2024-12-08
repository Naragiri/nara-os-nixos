{ lib, ... }:
_: prev: {
  xivlauncher = (prev.xivlauncher.override { useSteamRun = true; }).overrideAttrs (oldAttrs: {
    version = oldAttrs.version + "-gamemode";

    postFixup =
      let
        gamemode-path = lib.makeLibraryPath [ prev.gamemode ];
      in
      oldAttrs.postFixup
      + ''
        wrapProgram $out/bin/XIVLauncher.Core \
          --prefix LD_PRELOAD : ${gamemode-path}/libgamemodeauto.so \
          --prefix LD_PRELOAD : ${gamemode-path}/libgamemode.so
      '';
  });
}
