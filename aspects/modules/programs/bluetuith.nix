{
  exo.core =
    { pkgs, ... }:
    {
      my.xdg.desktopTuiEntries."Bluetuith" = {
        package = pkgs.bluetuith;
        width = 1200;
        height = 600;
      };
    };
}
