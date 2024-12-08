{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  inherit (lib.nos) enabled;
in
inputs.devenv.lib.mkShell {
  inherit inputs pkgs;

  modules = [
    (
      { pkgs, ... }:
      {
        packages = [
          pkgs.nvfetcher

          pkgs.deadnix
          pkgs.nixfmt-rfc-style
          pkgs.statix
          pkgs.stylua
          pkgs.treefmt
        ];

        pre-commit = {
          hooks = {
            deadnix = enabled // {
              excludes = [
                "generated.nix"
              ];
              settings = {
                edit = true;
              };
            };
            nixfmt-rfc-style = enabled // {
              excludes = [ "generated.nix" ];
            };
            statix = enabled // {
              excludes = [ "generated.nix" ];
            };
            stylua = enabled;
          };
        };
      }
    )
  ];
}
