{ inputs, ... }:
{
  flake-file.inputs.vivaldi.url = "github:Hy4ri/vivaldi-snapshot-flake";
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [ inputs.vivaldi.overlays.default ];
      hj.packages = [ pkgs.vivaldi-snapshot ];
    };
}
