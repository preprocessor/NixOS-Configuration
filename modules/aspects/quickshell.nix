{ inputs, ... }:
{
  flake-file.inputs.qml-niri = {
    url = "github:imiric/qml-niri/main";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-parts.follows = "flake-parts";
    };
  };

  flake.modules.nixos.desktop =
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
        extraPackages = quickshellDeps;
        env = {
          QT_QPA_PLATFORMTHEME = "gtk3";
          QML_IMPORT_PATH = qmlImportPath;
          QML2_IMPORT_PATH = qmlImportPath;
        };
      };
    in
    {
      fonts.packages = with pkgs; [
        lucide
      ];

      hj.packages = [ quickshellWrapped ];
    };

}
