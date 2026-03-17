{ self, ... }:
let
  inherit (self.lib) mkSystem;
  inherit (self.modules) nixos homeManager;
in
{
  flake.nixosConfigurations.ramiel = mkSystem {
    nixosModules = with nixos; [
      ramiel
      wayland
      desktop
      scheme
    ];
    homeModules = with homeManager; [
      ramiel
      wayland
      desktop
      shell
    ];
    configuration = {
      system = "x86_64-linux";
    };
  };
}
