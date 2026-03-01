{
  description = "A Nix-flake-based Nix development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # unstable Nixpkgs
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nixd
            cachix
            lorri
            niv
            nixfmt
            statix
            vulnix
            haskellPackages.dhall-nix
            lua51Packages.lua
            lua51Packages.luarocks
            lua-language-server
          ];
        };
      }
    );
}
