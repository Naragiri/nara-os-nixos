{
  description = "NaraOS NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # i hate nintendo.
    yuzu-fix.url =
      "github:nixos/nixpkgs/d89fdbfc985022d183073cb52df4d35b791d42cf";

    old-minecraft.url =
      "github:nixos/nixpkgs/8e644bcfa7afa8045ff717b119126c709b41bf3f";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixvim.url = "github:nix-community/nixvim/nixos-23.11";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "naraos-nixos-flake";
            title = "NaraOS NixOS";
          };

          namespace = "nos";
        };
      };
    in (lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-25.9.0" ];
      };

      systems.hosts.hades.modules = [ ./disks/hades.nix ];

      systems.hosts.zeus.modules = [ ./disks/zeus.nix ];

      templates = import ./templates { };

      outputs-builder = channels: {
        checks.pre-commit-check =
          inputs.pre-commit-hooks.lib.${channels.nixpkgs.system}.run {
            src = ./.;
            hooks = { treefmt.enable = true; };
          };
      };
    });
}
