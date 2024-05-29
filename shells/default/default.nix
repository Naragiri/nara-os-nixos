{ pkgs, inputs, channels, ... }:
pkgs.mkShell {
  inherit (inputs.self.checks.${channels.nixpkgs.system}.pre-commit-check)
    shellHook;
  packages = with pkgs; [ nixfmt treefmt nvfetcher ];
}
