{ inputs, ... }:
{
  w.ramiel =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [ inputs.neovim.overlays.default ];
    };
}
