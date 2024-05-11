{ pkgs, inputs, channels, ... }:
pkgs.mkShell {
  inherit (inputs.self.checks.${channels.nixpkgs.system}.pre-commit-check)
    shellHook;
  nativeBuildInputs = with pkgs; [ nixfmt treefmt ];
}
