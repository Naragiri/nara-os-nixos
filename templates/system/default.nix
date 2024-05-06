{ lib, ... }:
with lib;
with lib.nos; {
  imports = [ ./hardware-configuration.nix ];

  # nos = {
  #     hardware = {
  #       network = enabled;
  #       audio = enabled;
  #     };
  #   system = {
  #     boot.grub = enabled;
  #     security.doas = enabled;
  #   };
  # };

  system.stateVersion = "23.11";
}
