{
  w.default =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        qt6Packages.qt6ct
        qt6Packages.qtstyleplugin-kvantum
        qt6Packages.qtwayland
      ];

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
