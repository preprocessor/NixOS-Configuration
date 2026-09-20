{
  exo.core =
    { pkgs, ... }:
    {
      my.xdg.desktopTuiEntries."Wifitui" = {
        package = pkgs.wifitui;
        width = 1200;
        height = 1200;
      };
    };
}
