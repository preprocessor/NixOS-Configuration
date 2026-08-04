{
  exo.mods.desktop =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.rmpc ];
    };
}
