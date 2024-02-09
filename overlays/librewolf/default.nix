{ channels, ... }:

final: prev:
{
  inherit (channels.unstable) librewolf;
}