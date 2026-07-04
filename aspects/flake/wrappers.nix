{ inputs, ... }:
{
  inputs.birdee = {
    url = "github:BirdeeHub/nix-wrapper-modules";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  perSystem = {
    _module.args = { inherit (inputs) birdee; };
  };
}
