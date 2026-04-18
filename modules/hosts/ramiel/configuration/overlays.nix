{ inputs, ... }:
{
  flake.modules.nixos.ramiel =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [
        inputs.neovim.overlays.default
        inputs.rabid.overlays.default
        inputs.gimp.overlays.default
      ];

      hj.packages = with pkgs; [
        hand-of-evil
        gimp
      ];
    };
}
