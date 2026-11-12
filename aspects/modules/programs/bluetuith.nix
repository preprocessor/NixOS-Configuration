{
  modules.core = { pkgs, ... }: {
    hj.packages = [ pkgs.bluetuith ];
  };

  modules.features.desktop =
    { pkgs, ... }:
    {
      my.xdg.desktopTuiEntries."Bluetuith" = {
        package = pkgs.bluetuith;
        width = 1200;
        height = 600;
      };
    };
}
