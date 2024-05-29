{ writeShellScriptBin, nix-output-monitor, fd, nvfetcher, ... }:
writeShellScriptBin "nos" ''
  rebuild() {
    pkexec nixos-rebuild switch --flake $FLAKE_DIR# --log-format internal-json --verbose |& ${nix-output-monitor}/bin/nom --json
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
      minimal) ;;
      *) echo "Unknown configuration." && exit ;;
    esac
    nix build $FLAKE_DIR#install-isoConfigurations."$ISO_TYPE" --log-format internal-json -v |& ${nix-output-monitor}/bin/nom --json
  }

  update-pkgs() {
    mapfile -t pkg_tomls < <(${fd}/bin/fd nvfetcher.toml $FLAKE_DIR/packages)
    for pkg_toml in "''${pkg_tomls[@]}"; do
        pkg_dir=$(dirname "$pkg_toml")
        nvfetcher --config "$pkg_toml" --build-dir "$pkg_dir"
    done
  }

  usage() {
    cat <<-_EOF
  Usage:
    nos rebuild
      Rebuild the system configuration.
    nos update
      Update the system flake inputs.
    nos clean
      Garbage collect and optimize the nix store.
    nos repair
      Attempts to check for issues and repair the nix store.
    nos build-iso
      Builds an iso from the install-iso systems.
      Valid types are: minimal
    nos update-pkgs
      Updates custom packages to the latest versions with nvfetcher.
  _EOF
  }

  if [ "$EUID" -eq 0 ]; then 
    echo "Do not run this program as root."
    echo "We will ask for elevated privellages as needed."
    exit
  fi

  FLAKE_DIR="$HOME/Repos/naraos/naraos-nixos-flake"
  case "$1" in
      rebuild|r) rebuild ;;
      update|u) update ;;
      clean|c) clean ;;
      repair|rp) repair ;;
      update-pkgs|up) update-pkgs ;;
      build-iso|bi) shift; ISO_TYPE="$1"; build-iso ;;
      *) usage ;;
  esac
''
