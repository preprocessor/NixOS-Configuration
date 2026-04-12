{ inputs, ... }:
{
  flake-file.inputs.dms.url = "path:/home/wyspr/Configuration/DankMaterialShell";
  flake-file.inputs.qml-niri.url = "github:imiric/qml-niri/main";

  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        lucide
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
          python3
        ]
        ++ (with pkgs.kdePackages; [
          qtmultimedia
        ]);

      qmlImportPath = (lib.makeSearchPath pkgs.kdePackages.qtbase.qtQmlPrefix quickshellDeps);

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
      home.packages = [ quickshellWrapped ];

    };
}
