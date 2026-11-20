{
  perSystem = { pkgs, ... }: {
    remotePackages = { inherit (pkgs) rpcs3; };
  };

  modules.features.gaming =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.rpcs3 ];
    };
}
