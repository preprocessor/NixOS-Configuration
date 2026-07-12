{ inputs, ... }:
{
  tack.birdee.url = "gh:BirdeeHub/nix-wrapper-modules";

  perSystem = {
    _module.args = { inherit (inputs) birdee; };
  };
}
