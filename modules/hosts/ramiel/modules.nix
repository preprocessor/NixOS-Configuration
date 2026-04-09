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
      # everforest
      # kanagawa-dragon
      tokyonight-night
    ];
    homeModules = with homeManager; [
      ramiel
      desktop
      # everforest
      # kanagawa-dragon
      tokyonight-night
    ];
    configuration = {
      system = "x86_64-linux";
    };
  };
}
