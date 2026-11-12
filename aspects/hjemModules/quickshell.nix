{
  flake.hjemModules.quickshell =
    {
      config,
      lib,
      pkgs,
      wrapPackage,
      ...
    }:
    let
      cfg = config.my.quickshell;
    in
    {
      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        hj.systemd.services.quickshell = {
          enableDefaultPath = false;
          description = "quickshell";
          after = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${lib.getExe cfg.package}";
            Restart = "on-failure";

            MemoryHigh = "512M";
            MemoryMax = "768M";
          };
        };
      };

      options.my.quickshell = {
        enable = lib.mkEnableOption "quickshell" // {
          default = true;
        };

        package = lib.mkOption {
          default =
            let
              runtimePackages = with pkgs; [
                kdePackages.qtmultimedia
                qt6.qtquick3d
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
            wrapPackage {
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
            };
        };
      };
    };
}
