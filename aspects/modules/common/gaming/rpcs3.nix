{
  modules.features.gaming =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.rpcs3 ];
    };
}
