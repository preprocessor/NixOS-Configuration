{
  exo.mods.gaming =
    { packages', ... }:
    {
      hj.packages = [ packages'.nix-gaming-edge.pokemmo ];
    };
}
