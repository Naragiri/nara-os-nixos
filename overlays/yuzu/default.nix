{ channels, ... }:
final: prev: {
  inherit (channels.yuzu-fix) yuzu-mainline yuzu-early-access;
}
