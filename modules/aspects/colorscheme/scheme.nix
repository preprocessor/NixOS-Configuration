{ inputs, ... }:
{
  flake.modules.nixos.scheme = {
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
