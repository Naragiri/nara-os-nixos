{...}: {
  imports = [ ./hardware-configuration.nix ];

  #system.boot.efi.enable = true;

  system.stateVersion = "23.11";

  { pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # nos = { 
  #   system = {
  #     hardware = {
  #       network.enable = true;
  #       audio.enable = true;
  #     };
  #     boot.grub.enable = true;
  #     security.doas.enable = true;
  #   };
  # };

  system.stateVersion = "23.11";
}
}