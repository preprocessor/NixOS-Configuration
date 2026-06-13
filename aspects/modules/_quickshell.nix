{
  ff = {
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
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
