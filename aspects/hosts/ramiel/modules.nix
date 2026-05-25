{
  inputs,
  self,
  withSystem,
  ...
}:
{
  flake.nixosConfigurations.ramiel = withSystem "x86_64-linux" (
    { self', inputs', ... }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit self' inputs';
        inherit (inputs) birdee;
      };
      modules = with self.modules.nixos; [
        default
        ramiel
        desktop
        # tokyonight-night
        gruvbox-dark-hard
        shell
      ];
    }
  );
}
