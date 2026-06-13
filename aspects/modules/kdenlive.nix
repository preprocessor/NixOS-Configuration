{
  w.desktop =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.kdePackages.kdenlive ];
    };
}
