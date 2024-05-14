{ lib, ... }:
with lib;
with lib.nos; {
  # Forcefully disable wireless.
  # It's not compatiable with NetworkManager.
  networking.wireless.enable = mkForce false;

  nos = {
    cli-apps = {
      lf = enabled;
      fastfetch = enabled;
    };
    hardware = { network = enabled; };
    services = { openssh = enabled; };
    system = { security = { doas = enabled; }; };
    tools = {
      common = enabled;
      direnv = enabled;
      disko = enabled;
      git = enabled;
      zoxide = enabled;
    };
    user.name = "nixos";
  };

  security.doas.extraRules = [{
    users = [ "nixos" ];
    keepEnv = true;
    noPass = true;
  }];
}
