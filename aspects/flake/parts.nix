{ inputs, lib, ... }:
{
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  imports = [ (lib.mkAliasOptionModule [ "w" ] [ "nixos" "modules" ]) ];

  systems = [ "x86_64-linux" ];

  perSystem =
    { system, ... }:
    let
      # Configure Nix to allow unfree packages.
      config.allowUnfree = true;
      pkgs = import inputs.nixpkgs { inherit system config; };
    in
    {
      # initialize the pkgs for perSystem to be the patched nixpkgs
      _module.args = { inherit pkgs; };

      formatter = pkgs.alejandra;

      _file = ./parts.nix;
    };

  _file = ./parts.nix;
}
