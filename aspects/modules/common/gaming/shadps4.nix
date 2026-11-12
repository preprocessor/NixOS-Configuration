{
  modules.features.gaming =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.shadps4-qtlauncher ];
    };
}
