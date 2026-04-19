{ inputs, ... }:
{
  ff = {
    base16.url = "github:SenchoPens/base16.nix";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.base16.follows = "base16";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  w.desktop = {
    imports = [
      inputs.base16.nixosModule
      inputs.stylix.nixosModules.stylix
    ];

    stylix = {
      enable = true;
      autoEnable = false;

      targets = {
        console.enable = true;
        # gtk.enable = true;
        gtksourceview.enable = true;
        # qt.enable = true;
      };
    };
  };
}
