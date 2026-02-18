{
  description = "eos - Enemies Of Symfony";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        eos = pkgs.callPackage ./package.nix { };
      in
      {
        packages = {
          default = eos;
          eos = eos;
        };

        apps.default = flake-utils.lib.mkApp { drv = eos; };

        devShells.default = import ./shell.nix { inherit pkgs; };
      });
}

