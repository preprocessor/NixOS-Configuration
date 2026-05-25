{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.eza ];

      hj.xdg.config.files.""
    };
}
