{ inputs, ... }:
{
  flake-file.inputs = {
    base16.url = "github:SenchoPens/base16.nix";
    stylix.url = "github:nix-community/stylix";
  };

  flake.modules.nixos.desktop = {
    imports = [
      inputs.base16.nixosModule
      inputs.stylix.nixosModules.stylix
    ];

    stylix = {
      enable = true;
      autoEnable = false;

      targets = {
        console.enable = true;
      };
    };
  };
}
