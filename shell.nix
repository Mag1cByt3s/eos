{ pkgs ? import <nixpkgs> { } }:

let
  eos = pkgs.callPackage ./package.nix { };
in
pkgs.mkShell {
  packages = [
    eos
  ];
}

