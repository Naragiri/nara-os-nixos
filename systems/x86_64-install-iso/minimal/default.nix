{ lib, config, ... }:
let
  inherit (lib) mkIf mkForce;
  inherit (lib.nos) enabled;

  username = "nixos";
in
{
  # Forcefully disable wireless.
  # It's not compatiable with NetworkManager.
  networking.wireless.enable = mkForce false;

  nos = {
    cli-apps = {
      lf = enabled;
      fastfetch = enabled;
    };
    hardware = {
      network = enabled;
    };
    services = {
      openssh = enabled;
    };
    system = {
      security = {
        doas = enabled;
      };
    };
    tools = {
      common = enabled;
      direnv = enabled;
      disko = enabled;
      git = enabled;
      zoxide = enabled;
    };
    user.name = "${username}";
  };

  security.doas.extraRules = mkIf config.nos.system.security.doas.enable [
    {
      users = [ "${username}" ];
      keepEnv = true;
      noPass = true;
    }
  ];
}
