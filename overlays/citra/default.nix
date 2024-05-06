{ channels, ... }:
final: prev: {
  inherit (channels.yuzu-fix) citra-nightly citra-canary;
}
