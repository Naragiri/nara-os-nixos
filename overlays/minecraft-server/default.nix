{ channels, ... }:
final: prev: {
  inherit (channels.old-minecraft) minecraft-server;
}
