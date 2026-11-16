{
  modules.core = { pkgs, ... }: {
    hj.packages = [ pkgs.wifitui ];
  };

  modules.features.desktop = { pkgs, ... }: {
    my.xdg.desktopTuiEntries."Wifitui" = {
      package = pkgs.wifitui;
      width = 1200;
      height = 1200;
    };
  };
}
