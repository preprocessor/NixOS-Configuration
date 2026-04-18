{ self, ... }:
let
  inherit (self.lib) mkSystem;
  inherit (self.modules) nixos;
in
{
  flake.nixosConfigurations.ramiel = mkSystem {
    nixosModules = with nixos; [
      ramiel
      desktop
      tokyonight-night
      shell
    ];
    homeModules = [ ];
    configuration = {
      system = "x86_64-linux";
    };
  };
}
