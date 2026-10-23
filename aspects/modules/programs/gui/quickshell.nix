{
  exo.mods.desktop =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    {
      hj.packages =

        let
          runtimePackages = with pkgs; [
            kdePackages.qtmultimedia
            ddcutil
            imagemagick
            cava
            python3
            hyprpaper
            app2unit
            libnotify
          ];

          qmlImportPath = lib.makeSearchPath pkgs.kdePackages.qtbase.qtQmlPrefix runtimePackages; # lib/qt-6/qml
          qtPluginPath = lib.makeSearchPath pkgs.kdePackages.qtbase.qtPluginPrefix runtimePackages; # lib/qt-6/plugins
        in
        [
          (wrapPackage {
            inherit runtimePackages;
            package = pkgs.quickshell;
            aliases = [ "qs" ];
            env = {
              QT_QPA_PLATFORMTHEME = "gtk3";
              QS_ICON_THEME = config.my.gtk.icons.name;
              QS_DROP_EXPENSIVE_FONTS = "1";
              QML_IMPORT_PATH = qmlImportPath;
              QML2_IMPORT_PATH = qmlImportPath;
              QT_PLUGIN_PATH = qtPluginPath;
              FONTCONFIG_FILE = pkgs.makeFontsConf { fontDirectories = [ pkgs.lucide ]; };
            };
          })
        ];
    };
}
