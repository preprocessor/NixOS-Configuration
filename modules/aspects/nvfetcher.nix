{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.nvfetcher ];
    };
}
