{
  ff = {
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qml-niri = {
      url = "github:imiric/qml-niri/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        quickshell.follows = "quickshell";
        flake-parts.follows = "flake-parts";
      };
    };
  };
  perSystem =
    { inputs', ... }:
    {
      packages.quickshell =
        (inputs'.qml-niri.packages.quickshell.override {
          withWayland = true;

          withJemalloc = false;

          withPipewire = false;
          withQtSvg = false;
          withNetworkManager = false;
          withPolkit = false;
          withHyprland = false;
          withPam = false;
          withX11 = false;
          withI3 = false;
        }).overrideAttrs
          { doCheck = false; };
    };
  w.desktop =
    {
      pkgs,
      lib,
      config,
      self',
      birdee,
      ...
    }:
    let
      quickshellWrapped = birdee.lib.wrapPackage {
        inherit pkgs;
        package = self'.packages.quickshell;
        aliases = [ "qs" ];
        env = {
          QT_QPA_PLATFORMTHEME = "gtk3";
        };
      };
    in
    {
      hj.packages = [ quickshellWrapped ];
    };
}
