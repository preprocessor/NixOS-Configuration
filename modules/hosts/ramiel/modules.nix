{ inputs, self, ... }:
let
  inherit (self.modules) nixos;
in
{
  flake.nixosConfigurations.ramiel = inputs.nixpkgs.lib.nixosSystem {
    modules = with nixos; [
      default
      ramiel
      desktop
      tokyonight-night
      shell
    ];
    system = "x86_64-linux";
  };
}
