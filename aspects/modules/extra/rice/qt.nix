{
  exo.mods.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs.qt6Packages; [
        qtstyleplugin-kvantum
        qtwayland
        qt6ct
      ];

      my.xdg.desktopEntries = {
        "qt5ct".noDisplay = true;
        "qt6ct".noDisplay = true;
        "kvantummanager".noDisplay = true;
      };

      hj.environment.sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_STYLE_OVERRIDE = "kvantum";
      };

      # use gtk theme on qt apps
      qt = {
        enable = true;
        platformTheme = "qt5ct";
        style = "kvantum";
      };
    };
}
