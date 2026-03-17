{ inputs, ... }:
{
  flake.modules.nixos.ramiel = {
    nixpkgs.overlays = [
      inputs.neovim.overlays.default
      inputs.rabid.overlays.default
      inputs.gimp.overlays.default
    ];
  };
}
