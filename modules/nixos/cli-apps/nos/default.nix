{ lib, config, pkgs, ... }:
with lib;
with lib.nos; {
  config = {
    environment.systemPackages = with pkgs;
      [
        (writeShellScriptBin "nos" ''
          rebuild() {
            if [ "$EUID" -ne 0 ]; then 
              echo "You must run as root to rebuild."
              exit
            fi
            nixos-rebuild switch --flake $FLAKE_DIR# --log-format internal-json --verbose |& ${nix-output-monitor}/bin/nom --json
          }

          update() {
            nix flake update $FLAKE_DIR
          }

          clean() {
            nix store optimise --verbose && nix store gc --verbose
          }

          repair() {
            nix-store --verify --check-contents --repair --verbose
          }

          build-iso() {
            case "$ISO_TYPE" in
              minimal|graphical) ;;
              *) echo "Unknown configuration." && exit ;;
            esac
            nix build $FLAKE_DIR#install-isoConfigurations."$ISO_TYPE" --log-format internal-json -v |& ${nix-output-monitor}/bin/nom --json
          }

          usage() {
            cat <<-_EOF
          Usage:
            nos rebuild
              Rebuild the system configuration.
              Must be run as root.
            nos update
              Update the system flake inputs.
            nos clean
              Garbage collect and optimize the nix store.
            nos repair
              Attempts to check for issues and repair the nix store.
            nos build-iso
              Builds an iso from the install-iso systems.
              Valid types are: minimal, graphical
          _EOF
          }

          FLAKE_DIR="/home/${config.nos.user.name}/Repos/naraos/naraos-nixos-flake"
          case "$1" in
              rebuild|r) rebuild ;;
              update|u) update ;;
              clean|c) clean ;;
              repair|rp) repair ;;
              build-iso|bi) shift; ISO_TYPE="$1"; build-iso ;;
              *) usage ;;
          esac
        '')
      ];
  };
}
