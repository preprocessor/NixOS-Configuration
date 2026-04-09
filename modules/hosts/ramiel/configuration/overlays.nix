{ inputs, ... }:
{
  flake.modules.nixos.ramiel.nixpkgs.overlays = [
    inputs.neovim.overlays.default
    inputs.rabid.overlays.default
    inputs.gimp.overlays.default
  ];

  flake.modules.homeManager.ramiel =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        hand-of-evil
        gimp
      ];
    };
}
