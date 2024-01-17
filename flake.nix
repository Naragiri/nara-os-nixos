{
  description = "NaraOS NixOS Configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
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
          name = "nara-os-nixos";
          title = "NaraOS NixOS";
        };

        namespace = "nos";
      };
    };
  in
  (lib.mkFlake {
    inherit inputs;
    src = ./.;

    channels-config.allowUnfree = true;

    deploy = lib.mkDeploy { inherit (inputs) self; };

    checks = builtins.mapAttrs
        (_system: deploy-lib:
          deploy-lib.deployChecks inputs.self.deploy)
        inputs.deploy-rs.lib;

    systems.modules.nixos = with inputs; [
      nix-ld.nixosModules.nix-ld
      disko.nixosModules.disko
    ];

    systems.hosts.hades.modules = [
      ./disks/hades.nix
    ];

    templates = import ./templates {};
  });
}