{ lib, ... }:
with lib;
with lib.nos; {
  # Forcefully disable wireless.
  # It's not compatiable with NetworkManager.
  networking.wireless.enable = mkForce false;

  nos = {
    cli-apps = {
      lf = enabled;
      neofetch = enabled;
    };
    hardware = { network = enabled; };
    services = { openssh = enabled; };
    system = {
      boot.systemd = enabled;
      security = { doas = enabled; };
    };
    tools = {
      common = enabled;
      direnv = enabled;
      disko = enabled;
      git = enabled;
      zoxide = enabled;
    };
    user.name = "nixos";
  };
}
