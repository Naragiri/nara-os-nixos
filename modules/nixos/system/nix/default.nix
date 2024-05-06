{ options, config, lib, pkgs, ... }:
with lib;
with lib.nos;
let cfg = config.nos.system.nix;
in {
  options.nos.system.nix = with types; {
    extraSubstituters =
      mkOpt (listOf str) [ ] "Additional cachix substituters.";
    extraTrustedPublicKeys =
      mkOpt (listOf str) [ ] "Additional publickeys for cachix substituters.";
  };

  config = {
    environment.systemPackages = with pkgs; [ deploy-rs ];

    nix = let users = [ "root" config.nos.user.name ];
    in {
      settings = {
        experimental-features = "nix-command flakes";
        http-connections = 50;
        warn-dirty = false;
        log-lines = 50;
        sandbox = "relaxed";
        auto-optimise-store = true;
        trusted-users = users;
        allowed-users = users;
        keep-outputs = true;
        keep-derivations = true;

        # Mainly for hyprland.
        substituters = cfg.extraSubstituters;
        trusted-public-keys = cfg.extraTrustedPublicKeys;
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
