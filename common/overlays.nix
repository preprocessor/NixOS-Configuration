{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.neovim.overlays.default
    inputs.river.overlays.default
  ];
}
