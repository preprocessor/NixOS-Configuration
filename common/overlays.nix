{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nixstart-nvim.overlays.default
  ];
}
