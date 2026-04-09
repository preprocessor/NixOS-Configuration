{ inputs, ... }:
{
  flake-file.inputs.dms.url = "path:/home/wyspr/Configuration/DankMaterialShell";
  flake-file.inputs.qml-niri.url = "github:imiric/qml-niri/main";

  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        inter
        font-awesome_6
      ];
    };

  flake.modules.homeManager.desktop =
    {
      pkgs,
      osConfig,
      lib,
      ...
    }:
    let
      quickshellDeps =
        with pkgs;
        [
          wlsunset
          cava
          imagemagick
          libsForQt5.qt5.qtgraphicaleffects
        ]
        ++ (with pkgs.kdePackages; [
          qtmultimedia
          breeze-icons
          qtbase
          qt5compat
          qt6ct
          kdialog
          syntax-highlighting
          qqc2-desktop-style
        ]);

      qmlImportPath = (lib.makeSearchPath pkgs.kdePackages.qtbase.qtQmlPrefix quickshellDeps);
      # + ":${pkgs.libsForQt5.kirigami2}/lib/${
      #   builtins.replaceStrings [ "full-" ] [ "" ] pkgs.qt5.full.name
      # }/qml";

      quickshellWrapped = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = inputs.qml-niri.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
        aliases = [ "qs" ];
        runtimeInputs = quickshellDeps;
        env = {
          QT_QPA_PLATFORMTHEME = "gtk3";
          QML_IMPORT_PATH = qmlImportPath;
          QML2_IMPORT_PATH = qmlImportPath;
        };
      };
    in
    {
      home.packages = with pkgs; [
        libsForQt5.kirigami2
        libsForQt5.kirigami-addons
        kdePackages.kirigami
        kdePackages.kirigami-addons
        quickshellWrapped
      ];

    };
}
