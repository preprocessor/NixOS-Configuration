{
  modules.core = { self', ... }: {
    hj.packages = [ self'.packages.systemctl-tui ];
  };

  modules.features.desktop = { self', ... }: {
    my.xdg.desktopTuiEntries."sct" = {
      package = self'.packages.systemctl-tui;
      width = 2100;
      height = 1200;
    };
  };
}
