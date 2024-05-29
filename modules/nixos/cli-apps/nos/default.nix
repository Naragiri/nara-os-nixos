{ lib, config, pkgs, ... }:
with lib;
with lib.nos; {
  config = { environment.systemPackages = with pkgs.nos; [ nos ]; };
}
