{ self, ... }:
let
  inherit (self.lib) mkSystem;
  inherit (self.modules) nixos homeManager;
in
{
  flake.nixosConfigurations.ramiel = mkSystem {
    nixosModules = with nixos; [
      ramiel
      desktop
      everforest
    ];
    homeModules = with homeManager; [
      ramiel
      desktop
      everforest
    ];
    configuration = {
      system = "x86_64-linux";
    };
  };
}
