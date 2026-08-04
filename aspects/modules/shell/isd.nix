{
  exo.core =
    { pkgs, ... }:
    {
      my.xdg.desktopTuiEntries."isd" = {
        package = pkgs.isd;
        width = 2100;
        height = 1200;
      };
    };
}
