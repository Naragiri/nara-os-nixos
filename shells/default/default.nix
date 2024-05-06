{ pkgs, ... }:
pkgs.mkShell { nativeBuildInputs = with pkgs; [ alejandra nixfmt treefmt ]; }
