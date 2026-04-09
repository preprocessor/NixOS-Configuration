{ inputs, ... }:
{
  flake-file.inputs.vivaldi.url = "github:Hy4ri/vivaldi-snapshot-flake";
  flake.modules.nixos.default.nixpkgs.overlays = [ inputs.vivaldi.overlays.default ];
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.vivaldi-snapshot ];
    };
}
