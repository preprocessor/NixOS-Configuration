rec {
  flake = builtins.getFlake (toString ./.);
  nixos = flake.nixosConfigurations.ramiel.config;
  home = nixos.home-manager.users.wyspr;
}
