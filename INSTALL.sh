#!/bin/bash

nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disks/hades.nix
# nixos-generate-config --no-filesystems --root /mnt