{
  exo.core =
    { pkgs, ... }:
    {
      my.xdg.desktopTuiEntries."Wiremix" = {
        package = pkgs.wiremix;
        width = 1000;
        height = 600;
      };
    };
}
