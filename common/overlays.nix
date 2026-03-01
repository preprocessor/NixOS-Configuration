{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.neovim.overlays.default
    # inputs.hevel.overlays.default
    inputs.river.overlays.default
  ];
}
